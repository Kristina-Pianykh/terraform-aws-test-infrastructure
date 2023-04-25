resource "aws_ecr_repository" "data_import_ecr" {
  name                 = "db-data-import-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policies_tagged" {
  repository = aws_ecr_repository.data_import_ecr.name

  policy = <<POLICY
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last image",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
POLICY
}

resource "aws_ecs_cluster" "data_import" {
  name = "data-import-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "data_import" {
  family = "data_import-task_definition"
  container_definitions = jsonencode(
    [
      {
        name      = "data-import-task-definition",
        image     = aws_ecr_repository.data_import_ecr.repository_url,
        essential = true,
        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group         = aws_cloudwatch_log_group.ecs_service_log_group.name,
            awslogs-region        = var.region,
            awslogs-stream-prefix = "ecs"
          },
        },
        portMappings = [
          {
            containerPort = 80,
            hostPort      = 80,
            protocol      = "tcp"
          }
        ],
        memory = 512,
        cpu    = 256
      }
    ]
  )
  requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
  network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
  memory                   = 512         # Specify the memory the container requires
  cpu                      = 256         # Specify the CPU the container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "app_service" {
  name            = "data-import-service"
  cluster         = aws_ecs_cluster.data_import.id
  task_definition = aws_ecs_task_definition.data_import.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for subnet in aws_subnet.subnet : subnet.id if subnet.availability_zone == "eu-west-1a"]
    assign_public_ip = true                                   # Provide the containers with public IPs
    security_groups  = [aws_security_group.public_default.id] # Set up the security group
  }
}

resource "aws_cloudwatch_log_group" "ecs_service_log_group" {
  name = "ecs/data-import-service"
}

resource "aws_cloudwatch_event_rule" "on_db_launch" {
  name        = "load_data_on_db_launch"
  description = "Trigger the data import task on ECS when the database is launched"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.rds"
  ],
  "detail-type": [
    "RDS DB Instance Event"
  ],
  "detail": {
    "EventCategories": [
      "creation"
    ],
    "SourceType": [
      "DB_INSTANCE"
    ],
    "SourceArn": [
      "${aws_db_instance.demo_db.arn}"
    ],
    "Message": [
      "DB instance created"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "ecs_service" {
  target_id = "data_import"
  rule      = aws_cloudwatch_event_rule.on_db_launch.name
  arn       = aws_ecs_cluster.data_import.arn
  role_arn  = aws_iam_role.ecsTaskExecutionRole.arn
  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.data_import.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = [for subnet in aws_subnet.subnet : subnet.id if subnet.availability_zone == "eu-west-1a"]
      assign_public_ip = true
      security_groups  = [aws_security_group.public_default.id]
    }
  }
}

resource "aws_cloudwatch_log_group" "rds_creation_event_log_group" {
  name              = "/aws/events/${aws_db_instance.demo_db.db_name}/logs"
  retention_in_days = 1
}

data "aws_iam_policy_document" "cloudwatch_event_log_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.rds_creation_event_log_group.arn}:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.rds_creation_event_log_group.arn}:*:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnEquals"
      values   = [aws_cloudwatch_event_rule.rds_creation_event_log_group.arn]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_event_log_policy" {
  policy_document = data.aws_iam_policy_document.cloudwatch_event_log_policy.json
  policy_name     = "cloudwatch_event_log_policy"
}
