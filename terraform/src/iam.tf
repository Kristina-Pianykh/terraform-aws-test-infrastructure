data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_group" "admin" {
  group_name = var.admin_group_name
}

resource "aws_iam_group_policy_attachment" "admin_full_s3_access" {
  group      = data.aws_iam_group.admin.group_name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
}

data "aws_iam_policy_document" "ec2_sqs_access_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_sqs_access_role" {
  description        = "Role for EC2 with full access to SQS"
  name               = "ec2_sqs_access_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_sqs_access_role.json
}

data "aws_iam_policy" "sqs_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "dbt-attach-policy" {
  role       = aws_iam_role.ec2_sqs_access_role.name
  policy_arn = data.aws_iam_policy.sqs_full_access.arn
}
