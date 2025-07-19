import boto3
import botocore

def lambda_handler(event, context):

    asg_client = boto3.client("autoscaling")

    asg_response = asg_client.update_auto_scaling_group(
        AutoScalingGroupName = event["AutoScalingGroupName"],
        MinSize = event["MinSize"],
        DesiredCapacity = event["DesiredCapacity"]
    )
    return asg_response