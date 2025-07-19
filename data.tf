# Defining data sources

# Defining data source for base AMI
data "aws_ssm_parameter" "amz_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Defining data source for IP of terraform environment
data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

# Defining data source of AMI for Launch Template
data "aws_ami" "initial_launch_template_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Type"
    values = ["NightlyBuildImage"]
  }
}

# Defining data sources for IAM policies

# IAM policy document for assuming roles
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Defining access to existing IAM policies

data "aws_iam_policy" "basic_execution_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "run_instances_policy" {
  name = "RunInstances"
}

data "aws_iam_policy" "terminate_instances_policy" {
  name = "TerminateInstances"
}

data "aws_iam_policy" "create_tags_policy" {
  name = "CreateTags"
}

data "aws_iam_policy" "describe_instances_policy" {
  name = "DescribeInstances"
}

data "aws_iam_policy" "create_image_policy" {
  name = "CreateImage"
}

data "aws_iam_policy" "invoke_lambda_policy" {
  name = "InvokeFunction"
}

data "aws_iam_policy" "describe_images_policy" {
  name = "DescribeImages"
}

data "aws_iam_policy" "deregister_images_policy" {
  name = "DeregisterImage"
}

data "aws_iam_policy" "update_launch_template_policy" {
  name = "UpdateLauchTemplate"
}

data "aws_iam_policy" "publish_sns_policy" {
  name = "PublishSNS"
}

data "aws_iam_policy" "start_step_function_policy" {
  name = "StartStepFunction"
}

data "aws_iam_policy" "get_wp_archive_from_s3_policy" {
  name = "GetWPArchiveFromS3"
}

data "aws_iam_policy" "update_autoscaling_group_policy" {
  name = "UpdateAutoscalingGroup"
}

data "aws_iam_policy" "invoke_autoscaling_savings_functions_policy" {
  name = "InvokeASGSavingsMode"
}

# Defining data sources for ZIP archives of AWS Lambda Functions

data "archive_file" "run_instance" {
  type        = "zip"
  source_file = "Lambda-Functions/src/run_instance.py"
  output_path = "Lambda-Functions/archive/run_instance.zip"
}

data "archive_file" "create_ami" {
  type        = "zip"
  source_file = "Lambda-Functions/src/create_ami.py"
  output_path = "Lambda-Functions/archive/create_ami.zip"
}

data "archive_file" "check_for_tag" {
  type        = "zip"
  source_file = "Lambda-Functions/src/check_for_tag.py"
  output_path = "Lambda-Functions/archive/check_for_tag.zip"
}

data "archive_file" "check_ami_state" {
  type        = "zip"
  source_file = "Lambda-Functions/src/check_ami_state.py"
  output_path = "Lambda-Functions/archive/check_ami_state.zip"
}

data "archive_file" "update_launch_template" {
  type        = "zip"
  source_file = "Lambda-Functions/src/update_launch_template.py"
  output_path = "Lambda-Functions/archive/update_launch_template.zip"
}

data "archive_file" "terminate_instance" {
  type        = "zip"
  source_file = "Lambda-Functions/src/terminate_instance.py"
  output_path = "Lambda-Functions/archive/terminate_instance.zip"
}

data "archive_file" "set_asg_to_idle" {
  type        = "zip"
  source_file = "Lambda-Functions/src/set_asg_to_idle.py"
  output_path = "Lambda-Functions/archive/set_asg_to_idle.zip"
}

data "archive_file" "set_asg_to_active" {
  type        = "zip"
  source_file = "Lambda-Functions/src/set_asg_to_active.py"
  output_path = "Lambda-Functions/archive/set_asg_to_active.zip"
}
