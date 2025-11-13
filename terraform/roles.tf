resource "aws_iam_role" "lambda_role" {
  name               = "lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
}

resource "aws_iam_policy" "publish_sns" {
  name   = "lambda-publish-sns-policy"
  policy = data.aws_iam_policy_document.lambda_execution_policy.json
}

resource "aws_iam_policy_attachment" "lambda_execution_attachment" {
  name       = "lambda-execution-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.publish_sns.arn
}
