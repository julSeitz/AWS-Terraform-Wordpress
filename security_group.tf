# Creating Security Groups

# Creating Security Group for Bastion Host and relevant rules

# Creating Security Group for Bastion Host
resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion_host_sg"
  description = "Allow inbound SSH traffic from current IP and all outbound traffic"
  vpc_id      = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "Bastion Host SG"
  }
}

# Adding ingress rule allowing SSH access to bastion_host_sg Security Group from current IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule_bastion" {
  security_group_id = aws_security_group.bastion_host_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "${data.http.my_ip.response_body}/32"
}

# Adding egress rule allowing all egress traffic to bastion_host_sg Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_rule_bastion" {
  security_group_id = aws_security_group.bastion_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating Security Group for SSH access and relevant rules

# Creating Security Group for SSH access
resource "aws_security_group" "allow_ssh_sg" {
  name        = "allow_ssh"
  description = "Allow inbound SSH traffic from Bastion Host"
  vpc_id      = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "Allow SSH"
  }
}

# Adding ingress rule allowing SSH access to allow_ssh Security Group from Bastion Host
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
  security_group_id            = aws_security_group.allow_ssh_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.bastion_host_sg.id
}

# Adding egress rule allowing all egress traffic to bastion_host_sg Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_rule_ssh" {
  security_group_id = aws_security_group.allow_ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating Security Group for Application Load Balancer and relevant rules

# Creating Security Group for Appliaction Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allows HTTP traffic through the Application Load Balancer"
  vpc_id      = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "Application Load Balancer SG"
  }
}

# Adding ingress rule allowing HTTP access to alb_sg from current IP
resource "aws_vpc_security_group_ingress_rule" "allow_http_rule_alb" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "${data.http.my_ip.response_body}/32"
}

# Adding egress rule allowing all egress traffic from alb_sg
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_rule_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating Security Group for Web Server and relevant rules

# Creating Security Group for Web Server
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow inbound HTTP traffic and all outbound traffic"
  vpc_id      = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "Web Server SG"
  }
}

# Adding ingress rule allowing HTTP access to webserver_sg from current IP
resource "aws_vpc_security_group_ingress_rule" "allow_http_rule_webserver" {
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "${data.http.my_ip.response_body}/32"
}

# Adding ingress rule allowing HTTP acces to webserver_sg from alb_sg
resource "aws_vpc_security_group_ingress_rule" "allow_alb_rule" {
  security_group_id            = aws_security_group.webserver_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id
}

# Adding egress rule allowing all egress traffic from webserver_sg
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_rule_webserver" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
