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

    try:
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="Resources Running for more than 4 hours",
            Message=message,
        )
        logger.info("Message published to SNS topic successfully.")
    except Exception as e:
        logger.error("Error publishing message to SNS topic: %s", e)
        raise e
