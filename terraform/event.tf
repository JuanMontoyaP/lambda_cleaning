resource "aws_cloudwatch_event_rule" "every_8_hours" {
  name                = "every-8-hours"
  description         = "Triggers every 8 hours"
  schedule_expression = "rate(8 hours)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.every_8_hours.name
  arn  = aws_lambda_function.cleaner.arn

  input = jsonencode({
    message = "Lambda function triggered by EventBridge every 8 hours"
    regions = ["us-east-1", "us-west-1"]
  })
}

resource "aws_lambda_permission" "event_bridge_permission" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cleaner.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_8_hours.arn
}
