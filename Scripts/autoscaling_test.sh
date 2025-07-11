#!/bin/bash

###############################################################################################################################
# Bash script for testing if the Auto Scaling Group works, generating load on the server when receiving an HTTP request
###############################################################################################################################

# Redirecting any error messages to specified log file
exec 2>>/var/log/autoscaling_test.log

# Updating packages
yum update -y
# Installing apache
yum install -y httpd stress php

# Starting and enabling apache service
systemctl start httpd
systemctl enable httpd

# Writing php script for stress test to index.php file in /var/www/html directory
cat <<EOF > /var/www/html/index.php
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