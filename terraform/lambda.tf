resource "aws_lambda_function" "cleaner" {
  function_name    = "lambda_cleaner"
  filename         = "${path.module}/../lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda_function.zip")
  handler          = "main.lambda_handler"
  runtime          = "python3.13"
  role             = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.runtime_alerts.arn
    }
  }
}
