terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.0"
        }
    }
}

provider "aws" {
    region = "us-west-2"
}

resource "aws_vpc" "myVpc" {
    cidr_block = "10.0.0.0/26"

    tags = {
        Name = "MyVPC"
    }
}
resource "aws_subnet" "publicSubnet" {
    vpc_id = aws_vpc.myVpc.id
    cidr_block = "10.0.0.0/28"

    tags = {
        Name = "PublicSubnet"
    }
}

resource "aws_internet_gateway" "myIgw" {
    vpc_id  = aws_vpc.myVpc.id

    tags = {
        Name = "InternetGateway"
    }
}

resource "aws_route" "publicRoute" {
    gateway_id = aws_internet_gateway.myIgw.id
    route_table_id = aws_vpc.myVpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
}