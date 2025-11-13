import os
import boto3
import logging

logger = logging.getLogger()
logger.setLevel("INFO")

SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]


sns = boto3.client("sns")


def lambda_handler(event, context):

    print("Received event: %s", event)
    message = event.get("message", "No message provided")
    print(SNS_TOPIC_ARN)
