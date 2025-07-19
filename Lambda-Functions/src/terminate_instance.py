import boto3
import botocore

def lambda_handler(event, context):

    ec2_client = boto3.client("ec2")

    terminate_response = ec2_client.terminate_instances(
        InstanceIds = [
            event["InstanceId"]
        ]
    )

    event["TerminatedInstances"] = terminate_response["TerminatingInstances"]

    return event
