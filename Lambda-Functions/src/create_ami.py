import boto3
import botocore
from datetime import date

def lambda_handler(event, context):

   output = {
      "UserDataFinished": event["UserDataFinished"],
      "InstanceId": event["InstanceId"],
      "ImageAvailable": "",
      "ImageId": "",
      "TerminatedInstances": ""
   }

   ec2_client = boto3.client("ec2")

   create_response = ec2_client.create_image(
      InstanceId = event["InstanceId"],
      Name = "Nightly-AMI-Build-" + str(date.today()),
      Description = "Nightly AMI build for EC2 Autoscaling Group Instances based on Amazon Linux 2023",
      TagSpecifications = [
         {
            "ResourceType": "image",
            "Tags": [
               {
                  "Key": "Type",
                  "Value": "NightlyBuildImage"
               },
               {
                  "Key": "CreationDate",
                  "Value": str(date.today())
               }
            ]
         }
      ]
   )

   if "ImageId" in create_response:
      output["ImageId"] = create_response["ImageId"]
   return output