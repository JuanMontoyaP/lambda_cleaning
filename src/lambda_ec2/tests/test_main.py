import os
import boto3
import pytest
from moto import mock_aws

from lambda_ec2.main import publish_sns_message
from lambda_ec2.main import get_ec2_instances


class TestMain:
    region = "us-west-1"
    topic_name = "MyTopic"

    @pytest.fixture(autouse=True)
    def env_setup(self, monkeypatch):
        monkeypatch.setenv(
            "SNS_TOPIC_ARN", f"arn:aws:sns:{self.region}:123456789012:{self.topic_name}"
        )

    @pytest.fixture()
    def sns_setup(self):
        with mock_aws():
            sns = boto3.client("sns", region_name=self.region)
            sns.create_topic(Name=self.topic_name)
            yield

    @pytest.fixture()
    def ec2_setup(self):
        with mock_aws():
            ec2 = boto3.client("ec2", region_name=self.region)

            ec2.run_instances(
                ImageId="ami-12345678", MinCount=1, MaxCount=1, InstanceType="t2.micro"
            )

            yield

    def test_get_ec2_instances(self, ec2_setup):
        instances = get_ec2_instances(self.region)
        assert len(instances) == 1

    def test_publish_sns_message(self, sns_setup):
        topic_arn = os.environ["SNS_TOPIC_ARN"]
        subject = "Test Subject"
        message = "Test Message"

        publish_sns_message(topic_arn, subject, message)

        assert True  # If no exception is raised, the test passes

    def test_publish_sns_message_invalid_topic(self, caplog, sns_setup):
        invalid_topic_arn = "arn:aws:sns:us-west-1:123456789012:InvalidTopic"
        subject = "Test Subject"
        message = "Test Message"

        with pytest.raises(Exception):
            publish_sns_message(invalid_topic_arn, subject, message)

        assert "Failed to publish SNS message" in caplog.text
