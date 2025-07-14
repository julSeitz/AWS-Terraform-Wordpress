# Creating Route Tables, Routes and Route Table Associations

# Create Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associationg Public Subnet A with the Public Route Table
resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associationg Public Subnet B with the Public Route Table
resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

# Creating Private Route Table
resource "aws_route_table" "private_route_table" {
  depends_on = [aws_nat_gateway.nat_gateway]
  vpc_id     = aws_vpc.wordpress_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associating Private Route Table with Private Subnets
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(local.private_subnet_ids)
  subnet_id      = element(local.private_subnet_ids, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
