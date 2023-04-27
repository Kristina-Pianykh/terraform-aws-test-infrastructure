resource "aws_sqs_queue" "db_buffer" {
  name                        = "DBBuffer.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  message_retention_seconds   = 86400 # 1 day
  visibility_timeout_seconds  = aws_lambda_function.sqs_polling_lambda.timeout * 6
}

data "aws_iam_policy_document" "sqs_access_policy" {
  version   = "2012-10-17"
  policy_id = "EC2FullSQSAccessPolicy"
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_sqs_access_role.arn]
    }
    actions   = ["sqs:*"] # TODO: tighten the policy for the producer
    resources = [aws_sqs_queue.db_buffer.arn]
  }
}

resource "aws_sqs_queue_policy" "sqs_access_policy" {
  queue_url = aws_sqs_queue.db_buffer.id
  policy    = data.aws_iam_policy_document.sqs_access_policy.json
}
