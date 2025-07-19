# Creating AWS Lambda Functions

# AWS Lambda function to run a single EC2 instance to create an AMI from
resource "aws_lambda_function" "run_instance" {
  filename         = data.archive_file.run_instance.output_path
  function_name    = "run_instance"
  role             = aws_iam_role.run_instances_role.arn
  handler          = "run_instance.lambda_handler"
  source_code_hash = data.archive_file.run_instance.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment

  environment {
    variables = {
      instance_type        = var.instance_type
      image_id             = data.aws_ssm_parameter.amz_linux.value
      subnet_id            = aws_subnet.public_subnet_a.id
      instance_profile_arn = aws_iam_instance_profile.create_tags_instance_profile.arn
    }
  }
}

# AWS Lambda function to create an AMI from an EC2 instance with the given ID
resource "aws_lambda_function" "create_ami" {
  filename         = data.archive_file.create_ami.output_path
  function_name    = "create_ami"
  role             = aws_iam_role.create_image_role.arn
  handler          = "create_ami.lambda_handler"
  source_code_hash = data.archive_file.create_ami.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment
}

# AWS Lambda function to check if EC2 Instance with given ID has tag UserDataFinished with value True
resource "aws_lambda_function" "check_for_tag" {
  filename         = data.archive_file.check_for_tag.output_path
  function_name    = "check_for_tag"
  role             = aws_iam_role.describe_instances_role.arn
  handler          = "check_for_tag.lambda_handler"
  source_code_hash = data.archive_file.check_for_tag.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment
}

# AWS Lambda function to check if AMI with given ID is in state "available"
resource "aws_lambda_function" "check_ami_state" {
  filename         = data.archive_file.check_ami_state.output_path
  function_name    = "check_ami_state"
  role             = aws_iam_role.describe_images_role.arn
  handler          = "check_ami_state.lambda_handler"
  source_code_hash = data.archive_file.check_ami_state.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment
}

# AWS Lambda function to update Launch Template with given AMI ID, delete old version of Launch Template, delete older AMIs of this type and shut down EC2 instance
resource "aws_lambda_function" "update_launch_template" {
  filename         = data.archive_file.update_launch_template.output_path
  function_name    = "update_launch_template"
  role             = aws_iam_role.update_launch_template_role.arn
  handler          = "update_launch_template.lambda_handler"
  source_code_hash = data.archive_file.update_launch_template.output_base64sha256

  timeout = 10

  environment {
    variables = {
      LaunchTemplateId          = aws_launch_template.test_template.id,
      ImageRententionTimeInDays = var.image_retention_time_in_days
    }
  }

  runtime = var.python_runtime_environment
}

# AWS Lambda function to terminate EC2 instance with given ID
resource "aws_lambda_function" "terminate_instance" {
  filename         = data.archive_file.terminate_instance.output_path
  function_name    = "terminate_instance"
  role             = aws_iam_role.terminate_instance_role.arn
  handler          = "terminate_instance.lambda_handler"
  source_code_hash = data.archive_file.terminate_instance.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment
}

# AWS Lambda function to set autoscaling group instance count to 0
resource "aws_lambda_function" "set_asg_to_idle" {
  filename         = data.archive_file.set_asg_to_idle.output_path
  function_name    = "set_asg_to_idle"
  role             = aws_iam_role.update_autoscaling_group_role.arn
  handler          = "set_asg_to_idle.lambda_handler"
  source_code_hash = data.archive_file.set_asg_to_idle.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment
}

# AWS Lambda function to set autoscaling group instance count to given size
resource "aws_lambda_function" "set_asg_to_active" {
  filename         = data.archive_file.set_asg_to_active.output_path
  function_name    = "set_asg_to_active"
  role             = aws_iam_role.update_autoscaling_group_role.arn
  handler          = "set_asg_to_active.lambda_handler"
  source_code_hash = data.archive_file.set_asg_to_active.output_base64sha256

  timeout = 10

  runtime = var.python_runtime_environment
}
