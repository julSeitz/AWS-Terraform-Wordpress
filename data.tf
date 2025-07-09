# Defining data sources

# Data source for AMI
data "aws_ami" "amz_linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023*kernel*"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

# Data source for IP of terraform environment 
data "http" "myip" {
  url = "https://ipinfo.io/ip"
}