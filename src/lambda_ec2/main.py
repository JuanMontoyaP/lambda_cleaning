import os
import boto3
import logging

logger = logging.getLogger()
logger.setLevel("INFO")

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")

_sns_client = None


def get_sns_client():
    global _sns_client
    if _sns_client is None:
        try:
            region = os.environ.get("AWS_REGION")
            _sns_client = boto3.client("sns", region_name=region)
        except Exception as e:
            logger.error("Failed to create SNS client: %s", e)
            raise

    return _sns_client


def get_ec2_instances(region):
    ec2 = boto3.client("ec2", region_name=region)
    response = ec2.describe_instances()
    instances = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instances.append(instance)
    return instances


def publish_sns_message(topic_arn, subject, message):
    sns = get_sns_client()
    try:
        sns.publish(
            TopicArn=topic_arn,
            Subject=subject,
            Message=message,
        )
    except Exception as e:
        logger.error("Failed to publish SNS message: %s", e)
        raise


def lambda_handler(event, context):
    logger.info("Received event: %s", event)
    logger.info("Context: %s", context)

    regions = event.get("regions", [])
    message = event.get("message", "No message provided")

    if not regions:
        logger.warning("No regions provided in the event.")
        raise ValueError("Regions list is empty.")

    message = f"{message}\nRegions: {', '.join(regions)}"

    publish_sns_message(
        SNS_TOPIC_ARN,
        "Resources Running for more than 4 hours",
        message,
    )
