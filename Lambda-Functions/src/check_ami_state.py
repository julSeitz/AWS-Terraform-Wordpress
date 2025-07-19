import boto3
import botocore

def lambda_handler(event, context):

    ec2_client = boto3.client("ec2")

    response = ec2_client.describe_images(
        ImageIds = [
            event["ImageId"]
        ]
    )
    output = {
       "UserDataFinished": event["UserDataFinished"],
       "InstanceId": event["InstanceId"],
       "ImageAvailable": "",
       "ImageId": event["ImageId"],
       "TerminatedInstances": ""
    }
    if "State" in response["Images"][0]:
        if response["Images"][0]["State"] == "available":
            output["ImageAvailable"] = "True"
    return output