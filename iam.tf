# Creating IAM resources

# Creating IAM role to run instances
resource "aws_iam_role" "run_instances_role" {
  name               = "run_instances_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

locals {
  run_instance_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.run_instances_policy.arn
  ]
}

resource "aws_iam_role_policy_attachment" "run_instances_role_policy_attachments" {
  count      = length(local.run_instance_role_policies)
  role       = aws_iam_role.run_instances_role.name
  policy_arn = local.run_instance_role_policies[count.index]
}

# Creating IAM role to update Launch Templates
locals {
  update_launch_template_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.describe_images_policy.arn,
    data.aws_iam_policy.deregister_images_policy.arn,
    data.aws_iam_policy.update_launch_template_policy.arn,
    data.aws_iam_policy.terminate_instances_policy.arn
  ]
}

resource "aws_iam_role" "update_launch_template_role" {
  name               = "update_launch_template"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "update_launch_template_role_policy_attachments" {
  count      = length(local.update_launch_template_role_policies)
  role       = aws_iam_role.update_launch_template_role.name
  policy_arn = local.update_launch_template_role_policies[count.index]
}

# Creating IAM role and instance profile to create tags
locals {
  create_tags_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.create_tags_policy.arn
  ]
}

resource "aws_iam_role" "create_tags_role" {
  name               = "create_tags_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "create_tags_role_policy_attachments" {
  count      = length(local.create_tags_role_policies)
  role       = aws_iam_role.create_tags_role.name
  policy_arn = local.create_tags_role_policies[count.index]
}

resource "aws_iam_instance_profile" "create_tags_instance_profile" {
  name = "create_instance_profile"
  role = aws_iam_role.create_tags_role.name
}

# Creating IAM role to describe EC2 instances
locals {
  describe_instances_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.describe_instances_policy.arn
  ]
}

resource "aws_iam_role" "describe_instances_role" {
  name               = "describe_instances_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "describe_instances_role_policy_attachments" {
  count      = length(local.describe_instances_role_policies)
  role       = aws_iam_role.describe_instances_role.name
  policy_arn = local.describe_instances_role_policies[count.index]
}

# Creating IAM role for AWS Step Function
locals {
  ami_step_function_role_policies = [
    data.aws_iam_policy.invoke_lambda_policy.arn,
    data.aws_iam_policy.publish_sns_policy.arn
  ]
}

resource "aws_iam_role" "ami_step_function_role" {
  name               = "ami_step_function_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ami_step_function_role_policy_attachments" {
  count      = length(local.ami_step_function_role_policies)
  role       = aws_iam_role.ami_step_function_role.name
  policy_arn = local.ami_step_function_role_policies[count.index]
}

# Creating IAM role for creating AMIs
locals {
  create_image_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.create_image_policy.arn,
    data.aws_iam_policy.create_tags_policy.arn
  ]
}

resource "aws_iam_role" "create_image_role" {
  name               = "create_image_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "create_image_role_policy_attachments" {
  count      = length(local.create_image_role_policies)
  role       = aws_iam_role.create_image_role.name
  policy_arn = local.create_image_role_policies[count.index]
}

# Creating IAM role for desribing AMIs
locals {
  describe_images_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.describe_images_policy.arn
  ]
}

resource "aws_iam_role" "describe_images_role" {
  name               = "describe_images_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "describe_images_role_policy_attachments" {
  count      = length(local.describe_images_role_policies)
  role       = aws_iam_role.describe_images_role.name
  policy_arn = local.describe_images_role_policies[count.index]
}

# Creating IAM role for terminating EC2 instances
locals {
  terminate_instances_role_policies = [
    data.aws_iam_policy.basic_execution_policy.arn,
    data.aws_iam_policy.terminate_instances_policy.arn
  ]
}

resource "aws_iam_role" "terminate_instance_role" {
  name               = "terminate_instance_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "terminate_instances_role_policy_attachments" {
  count      = length(local.terminate_instances_role_policies)
  role       = aws_iam_role.terminate_instance_role.name
  policy_arn = local.terminate_instances_role_policies[count.index]
}

# Creating IAM role for executing a Step Function
locals {
  start_step_function_role_policies = [
    data.aws_iam_policy.start_step_function_policy.arn
  ]
}

resource "aws_iam_role" "start_step_function_role" {
  name               = "start_step_function_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "start_step_function_role_policy_attachments" {
  count      = length(local.start_step_function_role_policies)
  role       = aws_iam_role.start_step_function_role.name
  policy_arn = local.start_step_function_role_policies[count.index]
}

# Creating IAM role and instance profile for getting WordPress archive file from S3 bucket via VPC endpoint

locals {
  get_wp_archive_from_s3_role_policies = [
    data.aws_iam_policy.get_wp_archive_from_s3_policy.arn
  ]
}

resource "aws_iam_role" "get_wp_archive_from_s3_role" {
  name               = "get_wp_archive_from_s3_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "get_wp_archive_from_s3_role_policy_attachments" {
  count      = length(local.get_wp_archive_from_s3_role_policies)
  role       = aws_iam_role.get_wp_archive_from_s3_role.name
  policy_arn = local.get_wp_archive_from_s3_role_policies[count.index]
}

resource "aws_iam_instance_profile" "get_wp_archive_from_s3_instance_profile" {
  name = "get_wp_archive_from_s3_instance_profile"
  role = aws_iam_role.get_wp_archive_from_s3_role.name
}

# Creating role for updating autoscaling groups
locals {
  update_autoscaling_group_role_policies = [
    data.aws_iam_policy.update_autoscaling_group_policy.arn
  ]
}

resource "aws_iam_role" "update_autoscaling_group_role" {
  name               = "update_autoscaling_group_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "update_autoscaling_group_role_policy_attachments" {
  count      = length(local.update_autoscaling_group_role_policies)
  role       = aws_iam_role.update_autoscaling_group_role.name
  policy_arn = local.update_autoscaling_group_role_policies[count.index]
}
