# Creating VPC and components

# Create VPC
resource "aws_vpc" "myVpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "MyVPC"
    }
}

# Create Public Subnet
resource "aws_subnet" "publicSubnet" {
    vpc_id = aws_vpc.myVpc.id
    cidr_block = var.public_subnet_cidr

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