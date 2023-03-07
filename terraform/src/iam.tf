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
