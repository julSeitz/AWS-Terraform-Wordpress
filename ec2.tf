# Creating EC2 instance and relevant Security Group 

# Create Security Group for SSH access
resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh"
    description = "Allow inbound SSH traffic from current IP and all outbound traffic"
    vpc_id = aws_vpc.myVpc.id

    tags = {
        Name = "allow_ssh"
    }
}

# Add ingress rule allowing SSH access to allow_ssh Security Group from current IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
    security_group_id = aws_security_group.allow_ssh.id
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "${data.http.myip.response_body}/32"
}

# Add egress rule allowing all egress traffic to allow_ssh Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_ssh_sg" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create Security Group for HTTP access
resource "aws_security_group" "allow_http" {
    name = "allow_http"
    description = "Allow inbound HTTP traffic and all outbound traffic"
    vpc_id = aws_vpc.myVpc.id

    tags = {
      name = "allow_http"
    }
}

# Add ingress rule allowing HTTP access to allow_http Security Group from current IP
resource "aws_vpc_security_group_ingress_rule" "allow_http_rule" {
    security_group_id = aws_security_group.allow_http.id
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr_ipv4 = "${data.http.myip.response_body}/32"
}

# Add egress rule allowing all egress traffic to allow_http Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4_http_sg" {
    security_group_id = aws_security_group.allow_http.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1" # semantically equivalent to all ports
}

# Create EC2 instance
resource "aws_instance" "myInstance" {
    ami = data.aws_ssm_parameter.amz_linux.value
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.publicSubnet.id
    security_groups = [
        aws_security_group.allow_ssh.id,
        aws_security_group.allow_http.id
        ]
    associate_public_ip_address = "true"

    user_data = templatefile(
        "user_data.sh", {
            db_password = var.db_password
        }
    )

    tags =  {
        Name = "MyInstanceViaTerraform"
        OS = "Linux"
    }
}