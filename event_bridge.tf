# Creating EventBridge schedules

# Creating EventBridge schedule to trigger AMI build Step Function every night
resource "aws_scheduler_schedule" "nightly_ami_build_schedule" {
  name                = "nightly_ami_build_schedule"
  schedule_expression = "cron(0 3 * * ? *)" # Adjust to weekdays after testing

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_sfn_state_machine.build_ami_and_update_template.arn
    role_arn = aws_iam_role.start_step_function_role.arn
  }

  schedule_expression_timezone = "Europe/Berlin"
}

# Creating schedules to activate functions of savings mode

# Creating EventBridge schedule to trigger Lambda functions setting autoscaling group capacity and size to zero
resource "aws_scheduler_schedule" "set_asg_to_idle_schedule" {
  name                = "set_asg_to_idle_schedule"
  schedule_expression = var.activate_savings_mode_cron_expression # Adjust to weekdays after testing and set to 07:55 AM

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.set_asg_to_idle.arn
    role_arn = aws_iam_role.activate_savings_mode_role.arn

    input = jsonencode({
      AutoScalingGroupName = aws_autoscaling_group.test_autoscaling_group.name
    })
  }

  schedule_expression_timezone = "Europe/Berlin"
}

# Creating EventBridge schedule to trigger Lambda functions to stop RDS instance
resource "aws_scheduler_schedule" "stop_database_schedule" {
  name                = "stop_database_schedule"
  schedule_expression = var.activate_savings_mode_cron_expression # Adjust to weekdays after testing and set to 07:55 AM

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.stop_database.arn
    role_arn = aws_iam_role.activate_savings_mode_role.arn

    input = jsonencode({
      DBInstanceIdentifier = aws_db_instance.wordpress_db.identifier
    })
  }

  schedule_expression_timezone = "Europe/Berlin"
}

# Creating schedules to deactivate functions of savings mode

# Creating EventBridge schedule to trigger Lambda function setting autoscaling group capacity and size to desired size
resource "aws_scheduler_schedule" "set_asg_to_active_schedule" {
  name                = "set_asg_to_active_schedule"
  schedule_expression = var.deactivate_savings_mode_cron_expression # Adjust to weekdays after testing and set to 06:00 PM 

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.set_asg_to_active.arn
    role_arn = aws_iam_role.deactivate_savings_mode_role.arn

    input = jsonencode({
      AutoScalingGroupName = aws_autoscaling_group.test_autoscaling_group.name,
      MinSize              = var.autoscaling_min_capacity,
      DesiredCapacity      = var.autoscaling_desired_capacity
    })
  }

  schedule_expression_timezone = "Europe/Berlin"
}

# Creating EventBridge schedule to trigger Lambda functions to resume RDS instance
resource "aws_scheduler_schedule" "resume_database_schedule" {
  name                = "resume_database_schedule"
  schedule_expression = var.deactivate_savings_mode_cron_expression # Adjust to weekdays after testing and set to 07:55 AM

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.resume_database.arn
    role_arn = aws_iam_role.deactivate_savings_mode_role.arn

    input = jsonencode({
      DBInstanceIdentifier = aws_db_instance.wordpress_db.identifier
    })
  }

  schedule_expression_timezone = "Europe/Berlin"
}
