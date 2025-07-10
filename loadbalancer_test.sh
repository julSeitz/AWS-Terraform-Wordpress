#!/bin/bash

###############################################################################################################################
# Bash script for testing if the Application Load Balancer works, makes each instance put out unique information via Web Server
###############################################################################################################################

# Redirecting any error messages to specified log file
exec 2>>/var/log/loadbalancer_test.log

# Updating packages
yum update -y
# Installing apache
yum install -y httpd

# Starting and enabling apache service
systemctl start httpd
systemctl enable httpd

# Getting instance metadata and saving them in variables
availability_zone=$(ec2-metadata --availability-zone | sed 's/placement: //')
local_ip=$(ec2-metadata --local-ipv4 | sed 's/local-ipv4: //')

# Writing metadata to index.html file in /var/www/html directory
cd /var/www/html
echo "<!doctype html><html><head><title>This is an EC2 instance</title></head><body><p><strong>Welcome to this EC2 instance!</strong></p><p><strong>Availability Zone of this instance:</strong> $availability_zone</p><p><strong>Local IP of this instance:</strong> $local_ip</p></body></html>" > index.html