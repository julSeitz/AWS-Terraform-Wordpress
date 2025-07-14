# Creating EC2 Auto Scaling Groups

# Creating EC2 Launch Template
resource "aws_launch_template" "test_template" {
  name          = "auto_scaling_test"
  image_id      = data.aws_ssm_parameter.amz_linux.value
  instance_type = var.instance_type
  user_data     = base64encode(file("Scripts/alb_and_autoscaling_test.sh"))
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true

    security_groups = [
      aws_security_group.webserver_sg.id,
      aws_security_group.allow_ssh.id
    ]
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Test Template"
    }
  }
}

# Creating Auto Scaling Policy
resource "aws_autoscaling_policy" "test_policy" {
  name = "test_policy"

  autoscaling_group_name = aws_autoscaling_group.test_autoscaling_group.name

  policy_type = "TargetTrackingScaling"

  estimated_instance_warmup = 30

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20
  }
}

# Creating Auto Scaling Group
resource "aws_autoscaling_group" "test_autoscaling_group" {
  name             = "test_autoscaling_group"
  max_size         = 4
  min_size         = 2
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.test_template.id
    version = aws_launch_template.test_template.latest_version
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  vpc_zone_identifier = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

# Attaching Autscaling Group to ALB Target Group
resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = aws_autoscaling_group.test_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.autoscaling_tg.arn
}
