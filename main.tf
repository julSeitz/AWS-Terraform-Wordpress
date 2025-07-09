terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.0"
        }
    }
}

# Configure AWS provider
provider "aws" {
    region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "myVpc" {
    cidr_block = "10.0.0.0/26"

    tags = {
        Name = "MyVPC"
    }
}

# Create Public Subnet
resource "aws_subnet" "publicSubnet" {
    vpc_id = aws_vpc.myVpc.id
    cidr_block = "10.0.0.0/28"

    tags = {
        Name = "PublicSubnet"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "myIgw" {
    vpc_id  = aws_vpc.myVpc.id

    tags = {
        Name = "InternetGateway"
    }
}

# Create Route to Public Subnet
resource "aws_route" "publicRoute" {
    gateway_id = aws_internet_gateway.myIgw.id
    route_table_id = aws_vpc.myVpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
}

# Create Security Group for SSH access
resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh"
    description = "Allow inbound SSH traffic and all outbound traffic"
    vpc_id = aws_vpc.myVpc.id

    tags = {
        Name = "allow_ssh"
    }
}

# Add ingress rule allowing SSH access to allow_ssh Security Group
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
    security_group_id = aws_security_group.allow_ssh.id
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

# Add egress rule allowing all egress traffic to allow_ssh Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create EC2 instance
resource "aws_instance" "myInstance" {
    ami = "ami-05ee755be0cd7555c"
    instance_type = "t3.micro"
    key_name = "vockey"
    subnet_id = aws_subnet.publicSubnet.id
    security_groups = [aws_security_group.allow_ssh.id]
    associate_public_ip_address = "true"

    tags =  {
        Name = "MyInstanceViaTerraform"
        OS = "Linux"
    }
}