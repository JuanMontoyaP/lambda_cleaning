# Lambda function for deleting test EC2 instances

This Lambda function identifies and deletes test EC2 instances in your AWS account. It also publishes notifications to an SNS topic when instances are deleted.

## Features
- Scans for EC2 instances tagged as "labs" or "test"
- Deletes test EC2 instances
- Publishes notifications to an SNS topic when instances are deleted

