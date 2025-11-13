data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_execution_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sns:Publish"
    ]

    resources = [aws_sns_topic.runtime_alerts.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["${aws_cloudwatch_log_group.lambda_logs.arn}:log-stream:*"]
  }
}
