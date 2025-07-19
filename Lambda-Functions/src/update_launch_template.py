import boto3
import botocore
import os
from datetime import date, timedelta

def lambda_handler(event, context):

    ec2_client = boto3.client("ec2")

    output = {
        "UserDataFinished": event["UserDataFinished"],
        "InstanceId": event["InstanceId"],
        "ImageAvailable": event["ImageAvailable"],
        "ImageId": event["ImageId"],
        "TerminatedInstances": ""
    }

    terminate_response = ec2_client.terminate_instances(
        InstanceIds = [
            event["InstanceId"]
        ]
    )

    output["TerminatedInstances"] = terminate_response["TerminatingInstances"]

    new_version_response = ec2_client.create_launch_template_version(
        LaunchTemplateId = os.environ["LaunchTemplateId"],
        SourceVersion = "$Latest",
        VersionDescription = "Latest-AMI",
        LaunchTemplateData = {
            "ImageId": event["ImageId"]
        }
    )

    update_template_response = ec2_client.modify_launch_template(
        LaunchTemplateId = os.environ["LaunchTemplateId"],
        DefaultVersion = "$Latest"
    )

    oldest_version_to_keep = int(update_template_response["LaunchTemplate"]["LatestVersionNumber"]) - 2

    launch_template_versions_response = ec2_client.describe_launch_template_versions(
       LaunchTemplateId = os.environ["LaunchTemplateId"]
    )

    versions_to_delete = []

    for version in launch_template_versions_response["LaunchTemplateVersions"]:
       if oldest_version_to_keep > int(version["VersionNumber"]):
          versions_to_delete.append(str(version["VersionNumber"]))
          

    delete_old_version_response = ec2_client.delete_launch_template_versions(
        LaunchTemplateId = os.environ["LaunchTemplateId"],
        Versions = versions_to_delete
    )

    get_images_reponse = ec2_client.describe_images(
        Filters = [
            {
                "Name": "tag:Type",
                "Values": [
                    "NightlyBuildImage"
                ]
            }
        ]
    )

    cut_off_date = date.today() - timedelta(days=int(os.environ["ImageRententionTimeInDays"]))

    for image in get_images_reponse["Images"]:
        for tag in image["Tags"]:
            if tag["Key"] == "CreationDate":
              if date.fromisoformat(tag["Value"]) < cut_off_date:
                ec2_client.deregister_image(
                  ImageId = image["ImageId"],
                  DeleteAssociatedSnapshots = True
                )

    return output