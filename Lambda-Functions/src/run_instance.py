import boto3
import botocore
import os

def lambda_handler(event, context):

   ec2_client = boto3.client("ec2")

   output = {
      "UserDataFinished": "",
      "InstanceId": "",
      "ImageAvailable": "",
      "ImageId": "",
      "TerminatedInstances": ""
   }
   
   response = ec2_client.run_instances(
      ImageId = os.environ["image_id"],
      InstanceType = os.environ["instance_type"],
      MinCount = 1,
      MaxCount = 1,
      IamInstanceProfile = {
         "Arn": os.environ["instance_profile_arn"]
      },
      NetworkInterfaces = [
         {
            "DeviceIndex": 0,
            "AssociatePublicIpAddress": True,
            "SubnetId": os.environ["subnet_id"],
         }
      ],
      UserData="""#!/bin/bash

# For Amazon Linux 2023

# Installing packages
yum update -y
yum install -y php php-mysqlnd mariadb105-server httpd

# Starting and enabling Apache Webserver
systemctl start httpd
systemctl enable httpd

# Starting and enabling MariaDB
systemctl start mariadb
systemctl enable mariadb

instance_id=$(ec2-metadata -i | cut -d" " -f2)
aws ec2 create-tags --resources $instance_id --tags 'Key="UserDataFinished",Value="True"'"""
   )
   output["InstanceId"] = response["Instances"][0]["InstanceId"]
   return output
