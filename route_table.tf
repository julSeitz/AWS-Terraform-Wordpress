# Creating Route Tables, Routes and Route Table Associations

# Create Public Route Table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.myVpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIgw.id
    }

    tags = {
        Name = "Public Route Table"
    }
}

# Associationg Public Subnet A with the Public Route Table
resource "aws_route_table_association" "public_subnet_a_association" {
    subnet_id = aws_subnet.publicSubnetA.id
    route_table_id = aws_route_table.public_route_table.id
}

# Associationg Public Subnet B with the Public Route Table
resource "aws_route_table_association" "public_subnet_b_association" {
    subnet_id = aws_subnet.publicSubnetB.id
    route_table_id = aws_route_table.public_route_table.id
}