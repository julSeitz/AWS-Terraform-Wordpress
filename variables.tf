# Defining variables

# The AWS Region to deploy this infrastructure to
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-central-1"
}

# The instance type to use for EC2 instances
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# The name of the key pair to use for SSH access
variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# The CIDR block for the VPC
variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
}

# The CIDR block for the Public Subnet A
variable "public_subnet_a_cidr" {
  description = "CIDR of the Public Subnet A"
  type        = string
}

# The CIDR block for the Public Subnet B
variable "public_subnet_b_cidr" {
  description = "CIDR of the Public Subnet B"
  type        = string
}

# The CIDR block for the Private Subnet A
variable "private_subnet_a_cidr" {
  description = "CIDR of the Private Subnet A"
  type        = string
}

# The CIDR block for the Private Subnet B
variable "private_subnet_b_cidr" {
  description = "CIDR of the Private Subnet B"
  type        = string
}

# The WP database password
variable "db_password" {
  description = "Password for the wordpress database"
  type        = string
  sensitive   = true
}

# The first Availability Zone
variable "aws_availability_zone_a" {
  type        = string
  description = "Value for Availability Zone a"
  default     = "eu-central-1a"
}

# The second Availability Zone
variable "aws_availability_zone_b" {
  type        = string
  description = "Value for Availability Zone b"
  default     = "eu-central-1b"
}

# The Average CPU Utilization to aim for with Autoscaling
variable "target_load" {
  type        = number
  description = "Target value for ASGAverageCPUUtilization during Autoscaling"
  default     = 50
}

# The name of the database
variable "db_name" {
  type        = string
  description = "Name of the database"
}

# The user name for the DBMS
variable "db_user" {
  type        = string
  description = "User name for the database"
}

# The max amount of instances in Autoscaling Group
variable "autoscaling_max_capacity" {
  type        = number
  description = "value"
  default     = 2
}

# The min amount of instances in Autoscaling Group
variable "autoscaling_min_capacity" {
  type        = number
  description = "value"
  default     = 1
}

# The desired amount of instances in Autoscaling Group
variable "autoscaling_desired_capacity" {
  type        = number
  description = "value"
  default     = 1
}

# The email to send SNS notifications about errors to
variable "error_notification_email" {
  description = "Email notify about errors in important automated processes to"
  type        = string
}

# The number of days to keep nightly build AMIs
variable "image_retention_time_in_days" {
  description = "Number of days to keep nightly build images"
  type        = number
}

# The python version for AWS Lambda Functions
variable "python_runtime_environment" {
  description = "The python version for the lambda runtime environment"
  type        = string
}

# The name of the bucket to store WordPress application data in
variable "wordpress_application_bucket_name" {
  description = "The name of the bucket to store WordPress application data in"
  type        = string
}

# The prefix of the archive of WordPress application files within the S3 bucket
variable "wordpress_application_bucket_archive_prefix" {
  description = "The prefix of the archive of WordPress application files within the S3 bucket"
  type        = string
}

# The file name of the archive of WordPress application files within the S3 bucket
variable "wordpress_application_bucket_archive_file_name" {
  description = "The file name of the archive of WordPress application files within the S3 bucket"
  type        = string
}

# The cron expression to schedule the actication of savings mode
variable "activate_savings_mode_cron_expression" {
  description = "The cron expression to schedule the actication of savings mode"
  type        = string
}

# The cron expression to schedule the deactication of savings mode
variable "deactivate_savings_mode_cron_expression" {
  description = "The cron expression to schedule the deactication of savings mode"
  type        = string
}

# The variable to determine if infrastructure should be started in savings mode or not
variable "set_infrastructure_to_savings_mode" {
  description = "The variable to determine if infrastructure should be started in savings mode or not"
  type        = bool
  default     = false
}

# The name of the secret for the wordpress RDS database
variable "wordpress_secret_id" {
  description = "The name of the secret for the wordpress RDS database"
  type        = string
}

# The file name for the php script within S3 bucket to get secret for WordPress application
variable "wordpress_application_bucket_get_secret_php_file_name" {
  description = "The file name for the php script within S3 bucket to get secret for WordPress application"
  type        = string
}

# The prefix for the php script within S3 bucket to get secret for WordPress application
variable "wordpress_application_bucket_get_secret_php_prefix" {
  description = "The prefix for the php script within S3 bucket to get secret for WordPress application"
  type        = string
}
