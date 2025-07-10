# Creating EC2 instances

# Creating EC2 instances to test Application Load Balancer

# Creating test instance one
resource "aws_instance" "myTestInstanceOne" {
    ami = data.aws_ssm_parameter.amz_linux.value
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.publicSubnetA.id
    security_groups = [
        aws_security_group.allow_ssh.id,
        aws_security_group.webserver_sg.id
        ]

    user_data = file("loadbalancer_test.sh")

    tags =  {
        Name = "myTestInstanceOne"
        OS = "Linux"
    }
}

# Creating test instance two
resource "aws_instance" "myTestInstanceTwo" {
    ami = data.aws_ssm_parameter.amz_linux.value
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.publicSubnetB.id
    security_groups = [
        aws_security_group.allow_ssh.id,
        aws_security_group.webserver_sg.id
        ]

    user_data = file("loadbalancer_test.sh")

    tags =  {
        Name = "myTestInstanceTwo"
        OS = "Linux"
    }
}

# Creating and attaching target groups for Applicatin Load Balancer

# Creating target group one
resource "aws_lb_target_group" "test_group_one" {
    name = "test-group-one"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.myVpc.id

    health_check {
        port = 80
        protocol = "HTTP"
        timeout = 5
        interval = 10
    }
}

# Attaching target group one
resource "aws_lb_target_group_attachment" "one" {
    port = 80
    target_group_arn = aws_lb_target_group.test_group_one.arn
    target_id = aws_instance.myTestInstanceOne.id
}

# Creating target group two
resource "aws_lb_target_group" "test_group_two" {
    name = "test-group-two"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.myVpc.id

    health_check {
        port = 80
        protocol = "HTTP"
        timeout = 5
        interval = 10
    }
}

# Attaching target group two
resource "aws_lb_target_group_attachment" "two" {
    port = 80
    target_group_arn = aws_lb_target_group.test_group_two.arn
    target_id = aws_instance.myTestInstanceTwo.id
}