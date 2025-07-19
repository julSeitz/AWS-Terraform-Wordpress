#!/bin/bash

#####################################################################################################################################################
# Bash script for testing if the Auto Scaling Group and Load Balancer work together, generating load on the server when receiving an HTTP request and
# displaying instance specific metadata
#####################################################################################################################################################

# Redirecting any error messages to specified log file
exec 2>>/var/log/autoscaling_test.log

# Updating packages
yum update -y
# Installing apache
yum install -y httpd stress php

# Starting and enabling apache service
systemctl start httpd
systemctl enable httpd

# Getting instance metadata and saving them in variables
availability_zone=$(ec2-metadata --availability-zone | sed 's/placement: //')
local_ip=$(ec2-metadata --local-ipv4 | sed 's/local-ipv4: //')

# Writing instance metadata to index.html file in /var/www/html directory for ALB test
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<metahttp-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Load Balancing Test</title>
</head>

<body>
<p><strong>Availability Zone of this instance:</strong> $availability_zone</p><p><strong>Local IP of this instance:</strong> $local_ip</p>
</body>
</html>
EOF

# Writing php script for stress test to stress-test.php file in /var/www/html directory
cat <<EOF > /var/www/html/stress-test.php
<!DOCTYPE html>
<html>
<head>
<metahttp-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Web Server Stress Test</title>
</head>

<body>
<?php
# Stress the system for a maximum of 20 minutes.
echo("<h2>Generating load</h2>");
exec("stress --cpu 4 --io 1 --vm 1 --vm-bytes 128M --timeout 600s > /dev/null 2>/dev/null &");
?>
</body>
</html>
EOF