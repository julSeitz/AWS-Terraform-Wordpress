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
  username               = var.db_user
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.mariadb_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.wp_private_subnets.name
  allocated_storage      = 5
  storage_type           = "gp2"
  multi_az               = false
  skip_final_snapshot    = true
}

resource "aws_rds_instance_state" "wordpress_db_state" {
  identifier = aws_db_instance.wordpress_db.identifier
  state      = var.set_infrastructure_to_savings_mode ? "stopped" : "available"
}
