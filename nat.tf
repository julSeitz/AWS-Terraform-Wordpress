# Allocating Elastic IP and creating NAT Gateway

# Allocating Elastic IP
resource "aws_eip" "elastic_ip" {
  depends_on = [aws_internet_gateway.wordpress_igw]

}

# Creating NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_internet_gateway.wordpress_igw, aws_eip.elastic_ip]
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "NAT Gateway"
  }
}
