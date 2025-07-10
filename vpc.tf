# Creating VPC and components

# Create VPC
resource "aws_vpc" "wordpress_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "Wordpress VPC"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "wordpress_igw" {
    vpc_id  = aws_vpc.wordpress_vpc.id

    tags = {
        Name = "Internet Gateway"
    }
}