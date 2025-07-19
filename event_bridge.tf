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
