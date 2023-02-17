resource "aws_iam_user" "kris_user" {
  name = "kris"
}

resource "aws_iam_group" "admin_group" {
  name = "admin"
}

resource "aws_iam_user_group_membership" "kris_admin_membership" {
  user   = aws_iam_user.kris_user.name
  groups = [aws_iam_group.admin_group.name]
}
