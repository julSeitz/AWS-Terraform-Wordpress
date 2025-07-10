# Defining variables

# The AWS Region to deploy this infrastructure to
variable "aws_region" {
    description = "AWS region to deploy into"
    type = string
    default = "us-west-2"
}

# The instance type to use for EC2 instances
variable "instance_type"  {
    description = "EC2 instance type"
    type = string
}

# The name of the key pair to use for SSH access
variable "key_name" {
    description = "Key pair name for SSH access"
    type = string
}

# The CIDR block for the VPC
variable "vpc_cidr" {
    description = "CIDR of the VPC"
    type = string
}

# The CIDR block for the Public Subnet A
variable "public_subnet_a_cidr" {
    description = "CIDR of the Public Subnet"
    type = string
}

# The CIDR block for the Public Subnet B
variable "public_subnet_b_cidr" {
    description = "CIDR of the Public Subnet B"
    type = string
}

# The WP database password
variable "db_password" {
    description = "Password for the wordpress database"
    type = string
    sensitive = true
}

# The first Availability Zone
variable "aws_availability_zone_a" {
    type = string
    description = "Value for Availability Zone a"
    default = "us-west-2a"    
}

# The second Availability Zone
variable "aws_availability_zone_b" {
    type = string
    description = "Value for Availability Zone b"
    default = "us-west-2b"    
}