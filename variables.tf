# Defining variables

# The AWS Region to deploy this infrastructure to
variable "aws_region" {
    description = "AWS region to deploy into"
    type = string
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

# The CIDR block for the Public Subnet
variable "public_subnet_cidr" {
    description = "CIDR of the Public Subnet"
    type = string
}