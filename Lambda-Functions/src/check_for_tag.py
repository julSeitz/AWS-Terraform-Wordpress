import boto3
import botocore

def lambda_handler(event, context):

   ec2_client = boto3.client("ec2")

   output = {
      "UserDataFinished": "",
      "InstanceId": event["InstanceId"],
      "ImageAvailable": "",
      "ImageId": "",
      "TerminatedInstances": ""
   }

   response = ec2_client.describe_instances(
      InstanceIds = [
         event["InstanceId"]
      ]
   )

   instances = response["Reservations"][0]["Instances"]
   if "Tags" in instances[0]:
      for tag in instances[0]["Tags"]:
         if tag["Key"] == "UserDataFinished":
            output["UserDataFinished"] = tag["Value"]
   return output