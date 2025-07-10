#!/bin/bash

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

# Downloading Wordpress
cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* .
rm -rf wordpress latest.zip

# Setting up database
mysql -u root -e "CREATE DATABASE wordpress;"
mysql -u root -e "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY '${db_password}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wpuser/" wp-config.php
sed -i "s/password_here/${db_password}/" wp-config.php