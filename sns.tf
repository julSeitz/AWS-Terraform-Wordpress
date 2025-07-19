# Creating AWS Simple Notification Service resources

# Creating SNS topic about failure of AMI build Step Function
resource "aws_sns_topic" "build_ami_failure_topic" {
  name = "build_ami_failure_topic"
}

# Creating subscription to SNS topic about failure of AMI build Step Function for configured email
resource "aws_sns_topic_subscription" "build_ami_failure_sqs_target" {
  topic_arn = aws_sns_topic.build_ami_failure_topic.arn
  protocol  = "email"
  endpoint  = var.error_notification_email
}
