import boto3
import botocore

def lambda_handler(event, context):

    rds_client = boto3.client("rds")

    rds_response = rds_client.stop_db_instance(
        DBInstanceIdentifier = event["DBInstanceIdentifier"]
    )
    
    output = {
        "DBInstanceIdentifier": rds_response["DBInstance"]["DBInstanceIdentifier"],
        "DBInstanceStatus": rds_response["DBInstance"]["DBInstanceStatus"],
        "DBName": rds_response["DBInstance"]["DBName"],
        "Endpoint": rds_response["DBInstance"]["Endpoint"]

    }


    return output