resource "aws_ecr_repository" "data_load" {
  name = "data_load"
}

data "aws_iam_policy_document" "data_load_policy" {
  version = "2008-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ecr:*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_ecr_repository_policy" "data_load_policy" {
  repository = aws_ecr_repository.data_load.name
  policy     = data.aws_iam_policy_document.data_load_policy.json
}

resource "aws_ecs_cluster" "data_loader" {
  name = "data_loader"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.data_loader_ecs.name
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "data_loader_ecs" {
  name              = "data_loader_cluster"
  retention_in_days = 1
}
