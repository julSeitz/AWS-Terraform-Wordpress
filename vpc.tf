# Creating VPC and components

# Create VPC
resource "aws_vpc" "myVpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "MyVPC"
    }
}

# Create Public Subnet A
resource "aws_subnet" "publicSubnetA" {
    vpc_id = aws_vpc.myVpc.id
    cidr_block = var.public_subnet_a_cidr
    availability_zone = var.aws_availability_zone_a
    map_public_ip_on_launch = true

    tags = {
        Name = "PublicSubnet A"
    }
}

# Create Public Subnet B
resource "aws_subnet" "publicSubnetB" {
    vpc_id = aws_vpc.myVpc.id
    cidr_block = var.public_subnet_b_cidr
    availability_zone = var.aws_availability_zone_b
    map_public_ip_on_launch = true

    tags = {
        Name = "PublicSubnet B"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "myIgw" {
    vpc_id  = aws_vpc.myVpc.id

    tags = {
        Name = "InternetGateway"
    }
}