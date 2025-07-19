# Creating Step Functions

# Creating Step Function to build an AMI from a fresh Image with LAMP stack installed, update Launch Template with new AMI, delete old versions and terminate used EC2 instance
resource "aws_sfn_state_machine" "build_ami_and_update_template" {
  name     = "build_ami_and_update_template"
  role_arn = aws_iam_role.ami_step_function_role.arn
  type     = "EXPRESS"

  definition = templatefile(
    "Step-Functions/Build-Ami/build_ami_and_update_template.asl.json",
    {
      run_instance_function           = "run_instance",
      check_for_tag_function          = "check_for_tag",
      create_ami_function             = "create_ami",
      check_ami_state_function        = "check_ami_state",
      update_launch_template_function = "update_launch_template",
      terminate_instance_function     = "terminate_instance",
      sns_topic_arn                   = aws_sns_topic.build_ami_failure_topic.arn
    }
  )
}
