# Creating VPC and components

# Create VPC
resource "aws_vpc" "wordpress_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "Wordpress VPC"
    }
}

# Create Public Subnet A
resource "aws_subnet" "public_subnet_a" {
    vpc_id = aws_vpc.wordpress_vpc.id
    cidr_block = var.public_subnet_a_cidr
    availability_zone = var.aws_availability_zone_a
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet A"
    }
}

# Create Public Subnet B
resource "aws_subnet" "public_subnet_b" {
    vpc_id = aws_vpc.wordpress_vpc.id
    cidr_block = var.public_subnet_b_cidr
    availability_zone = var.aws_availability_zone_b
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet B"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "wordpress_igw" {
    vpc_id  = aws_vpc.wordpress_vpc.id

    tags = {
        Name = "Internet Gateway"
    }
}