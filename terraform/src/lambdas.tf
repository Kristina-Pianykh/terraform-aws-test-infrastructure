data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_key_monitoring_basic_role_policy" {
  role       = aws_iam_role.lambda_key_monitoring_alarm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "log_events_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/log_events"
  output_path = "${path.module}/log_events.zip"
}

resource "aws_lambda_function" "log_events_lambda" {
  filename         = data.archive_file.log_events_lambda_zip.output_path
  source_code_hash = data.archive_file.log_events_lambda_zip.output_base64sha256
  function_name    = "log_events"
  role             = var.lambda_key_monitoring_alarm_role_arn
  description      = "Lambda function to write logs from EventBridge to CloudWatch Logs"
  handler          = "log_events.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300

  depends_on = [
    aws_cloudwatch_log_group.log_events_lambda
  ]
}

resource "aws_cloudwatch_log_group" "log_events_lambda" {
  name              = "/aws/lambda/log_events"
  retention_in_days = 1
}
