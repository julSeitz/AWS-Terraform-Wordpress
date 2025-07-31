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

set -ex

# For Amazon Linux 2023

# Setting HOME variable for installation
export HOME=/root

# Installing apache
yum update -y
yum install -y httpd

# Starting and enabling Apache Webserver
systemctl start httpd
systemctl enable httpd

# Installing php and mariadb
yum install -y php php-mysqlnd mariadb105-server git

# Starting and enabling MariaDB
systemctl start mariadb
systemctl enable mariadb

# Restarting apache
systemctl restart httpd

# Installing APCU

yum install -y php-devel php-pear
pecl channel-update pecl.php.net
echo 'no' | pecl install apcu
echo 'extension=apcu.so' > /etc/php.d/20-apcu.ini
systemctl restart php-fpm.service

# Setting permissions

usermod -a -G apache ec2-user
cd /var/www
chown -R ec2-user:apache html
chmod 2755 html


# Installing composer

cd /var/www/html
wget https://getcomposer.org/installer
php installer --install-dir=/usr/local/bin --filename=composer
chmod 755 /usr/local/bin/composer
rm installer
sudo -u ec2-user composer --version
sudo -u ec2-user composer require aws/aws-sdk-php

instance_id=$(ec2-metadata -i | cut -d" " -f2)
aws ec2 create-tags --resources $instance_id --tags 'Key="UserDataFinished",Value="True"'"""
   )
   output["InstanceId"] = response["Instances"][0]["InstanceId"]
   return output
