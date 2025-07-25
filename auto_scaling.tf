# Creating EC2 Auto Scaling Groups

# Creating EC2 Launch Template
resource "aws_launch_template" "test_template" {
  name          = "auto_scaling_test"
  image_id      = data.aws_ami.initial_launch_template_ami.id
  instance_type = var.instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.wp_application_instance_profile.arn
  }

  user_data = base64encode(
    templatefile(
      "Scripts/user_data.tftpl",
      {
        wordpress_secret_arn  = aws_db_instance.wordpress_db.master_user_secret[0].secret_arn,
        aws_region            = var.aws_region,
        wp_script_file_name   = "${var.wordpress_application_bucket_get_secret_php_file_name}"
        wp_archive_file_name  = "${var.wordpress_application_bucket_archive_file_name}"
        wp_archive_object_uri = "${data.aws_s3_bucket.wordpress_application_data_bucket.id}/${var.wordpress_application_bucket_archive_prefix}/${var.wordpress_application_bucket_archive_file_name}",
        wp_script_object_uri  = "${data.aws_s3_bucket.wordpress_application_data_bucket.id}/${var.wordpress_application_bucket_get_secret_php_prefix}/${var.wordpress_application_bucket_get_secret_php_file_name}"
        db_name               = var.db_name,
        db_host               = aws_db_instance.wordpress_db.endpoint,
        wp_archive_object_uri = "${data.aws_s3_bucket.wordpress_application_data_bucket.id}/${var.wordpress_application_bucket_archive_prefix}/latest.zip"
      }
    )
  )
  key_name = var.key_name

  network_interfaces {

    security_groups = [
      aws_security_group.webserver_sg.id,
      aws_security_group.allow_ssh_sg.id
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
    target_value = var.target_load
  }
}

# Creating Auto Scaling Group
resource "aws_autoscaling_group" "test_autoscaling_group" {
  depends_on       = [aws_route_table_association.private_route_table_association]
  name             = "test_autoscaling_group"
  max_size         = var.set_infrastructure_to_savings_mode ? 0 : var.autoscaling_max_capacity
  min_size         = var.set_infrastructure_to_savings_mode ? 0 : var.autoscaling_min_capacity
  desired_capacity = var.autoscaling_desired_capacity

  launch_template {
    id      = aws_launch_template.test_template.id
    version = "$Default"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  vpc_zone_identifier = local.private_subnet_ids
}

# Attaching Autscaling Group to ALB Target Group
resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = aws_autoscaling_group.test_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.autoscaling_tg.arn
}
