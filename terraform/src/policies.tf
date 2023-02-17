resource "aws_iam_policy" "bucket_access_policy" {
  name = "ReadAndWriteAndDeleteAccessToBuckets"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::mybucket"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "arn:aws:s3:::mybucket/path/to/my/key"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "admin_bucket_access_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.bucket_access_policy.arn
}
