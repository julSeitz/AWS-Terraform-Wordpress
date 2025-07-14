# Creating Subnets

# Creating Public Subnets

# Create Public Subnet A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.aws_availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet A"
  }
}

# Create Public Subnet B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.aws_availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet B"
  }
}

# Creating Private Subnets

# Creating Private Subnet A
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.aws_availability_zone_a

  tags = {
    Name = "Private Subnet A"
  }
}

# Creating Private Subnet B
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.aws_availability_zone_b

  tags = {
    Name = "Private Subnet B"
  }
}

# Creating local variables for subnet lists
locals {
  public_subnet_ids = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  private_subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}
