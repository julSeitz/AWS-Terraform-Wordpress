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

# Creating Security Group for Database Server and relevant rules

# Creating Security Group for MariaDB RDS Server
resource "aws_security_group" "mariadb_sg" {
  name        = "mariadb_sg"
  description = "Allow inbound traffic for MariaDB"
  vpc_id      = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "MariaDB SG"
  }
}

# Adding ingress rule allowing MariaDB traffic to mariadb_sg from webserver_sg
resource "aws_vpc_security_group_ingress_rule" "allow_mariadb_ingress_rule_db" {
  security_group_id            = aws_security_group.mariadb_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.webserver_sg.id
}

# Adding egress rule allowing all traffic to mariadb_sg
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_rule_db" {
  security_group_id = aws_security_group.mariadb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating Security Group for Secrets Manager VPC Endpoint  and relevant rules

# Creating Security Group for Secrets Manager VPC Endpoint
resource "aws_security_group" "vpc_secrets_manager_endpoint_sg" {
  name        = "vpc_secrets_manager_endpoint_sg"
  description = "Allows access to VPC Endpoint for AWS Secrets Manager from WordPress Servers"
  vpc_id      = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "Secrets Manager VPC Endpoint SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ingress_rule_vpc_endpoint" {
  security_group_id            = aws_security_group.vpc_secrets_manager_endpoint_sg.id
  referenced_security_group_id = aws_security_group.webserver_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
}

# Adding egress rule allowing all traffic to vpc_secrets_manager_endpoint_sg
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_rule_vpc_endpoint" {
  security_group_id = aws_security_group.vpc_secrets_manager_endpoint_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
