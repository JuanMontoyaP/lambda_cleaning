resource "aws_sns_topic" "runtime_alerts" {
  name = "lambda-runtime-alerts"
}


resource "aws_sns_topic_subscription" "email_message" {
  topic_arn = aws_sns_topic.runtime_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
