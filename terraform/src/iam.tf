data "aws_iam_user" "kris" {
  user_name = "kris"
}

data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group" "admin" {
  name = var.admin_group_name
}

resource "aws_iam_group_membership" "admins" {
  name = "tf-testing-group-membership"

  users = [
    data.aws_iam_user.kris.user_name
  ]

  group = aws_iam_group.admin.name
}

resource "aws_iam_group_policy_attachment" "admin_full_s3_access" {
  group      = aws_iam_group.admin.name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
}
