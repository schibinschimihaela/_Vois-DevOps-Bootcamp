import boto3
import sys
import os
from dotenv import load_dotenv

load_dotenv()

TABLE_NAME = "ip_spectre_logs"
dynamodb = boto3.resource("dynamodb", region_name=os.getenv("AWS_REGION"))

def create_table():
    table = dynamodb.create_table(
        TableName=TABLE_NAME,
        KeySchema=[{"AttributeName": "ip", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "ip", "AttributeType": "S"}],
        BillingMode="PAY_PER_REQUEST",
    )
    table.wait_until_exists()
    print("DynamoDB table created")

def purge_table():
    table = dynamodb.Table(TABLE_NAME)
    scan = table.scan()
    with table.batch_writer() as batch:
        for item in scan.get("Items", []):
            batch.delete_item(Key={"ip": item["ip"]})
    print("Table purged")

if __name__ == "__main__":
    if sys.argv[1] == "create":
        create_table()
    elif sys.argv[1] == "purge":
        purge_table()
