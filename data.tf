# Defining data sources

# Data source for AMI
data "aws_ssm_parameter" "amz_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Data source for IP of terraform environment
data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}
