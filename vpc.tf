# Creating VPC and components

# Create VPC
resource "aws_vpc" "wordpress_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Wordpress VPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

# Creating VPC Gateway endpoint for S3
resource "aws_vpc_endpoint" "s3_wp_endpoint" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids   = [aws_route_table.private_route_table.id]
}

# Creating endpoint policy for VPC Gateway endpoint
resource "aws_vpc_endpoint_policy" "s3_wp_endpoint_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_wp_endpoint.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowReadS3WP",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.wordpress_application_data_bucket.arn}",
          "${aws_s3_bucket.wordpress_application_data_bucket.arn}/${var.wordpress_application_bucket_archive_prefix}/${var.wordpress_application_bucket_archive_file_name}",
          "${aws_s3_bucket.wordpress_application_data_bucket.arn}/${var.wordpress_application_bucket_get_secret_php_prefix}/${var.wordpress_application_bucket_get_secret_php_file_name}",

        ],
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalArn" : "${aws_iam_role.wp_application_role.arn}"
          }
        }
      }
    ]
  })
}

# Creating VPC Interface endpoint for AWS Secrets Manager
resource "aws_vpc_endpoint" "secrets_manager_wp_endpoint" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.aws_region}.secretsmanager"
  subnet_ids        = local.private_subnet_ids
  security_group_ids = [
    aws_security_group.vpc_secrets_manager_endpoint_sg.id
  ]
}
