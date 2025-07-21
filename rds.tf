# Dedicated AWS RDS database

# Creating RDS Subnet Group
resource "aws_db_subnet_group" "wp_private_subnets" {
  name        = "wp_private_subnets"
  description = "Subnet Group of Private Subnets for deployment of RDS instance"
  subnet_ids  = local.private_subnet_ids

  tags = {
    Name = "Wordpress Private Subnets"
  }
}

# Creating RDS database
resource "aws_db_instance" "wordpress_db" {
  db_name                = var.db_name
  engine                 = "mariadb"
  instance_class         = "db.t4g.micro"
  engine_version         = "10.5"
  vpc_security_group_ids = [aws_security_group.mariadb_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.wp_private_subnets.name
  allocated_storage      = 5
  storage_type           = "gp2"
  multi_az               = false
  skip_final_snapshot    = true
  username               = var.db_user

  manage_master_user_password = true
}
