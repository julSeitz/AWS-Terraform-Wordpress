# Creating EC2 instances

# Creating EC2 instances for Bastion Hosts

# Creating Bastion Host
resource "aws_instance" "bastion_host" {
  count         = 2
  ami           = data.aws_ssm_parameter.amz_linux.value
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(local.public_subnet_ids, count.index)
  security_groups = [
    aws_security_group.bastion_host_sg.id
  ]

  tags = {
    Name = "Bastion Host ${count.index + 1}"
    OS   = "Linux"
  }
}
