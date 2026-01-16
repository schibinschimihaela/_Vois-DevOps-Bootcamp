import os
import boto3
from datetime import datetime

TABLE_NAME = "ip_spectre_logs"
region = os.getenv("AWS_REGION")
dynamodb = boto3.resource("dynamodb", region_name=region)
table = dynamodb.Table(TABLE_NAME)

def save_log(ip, country, city, isp):
    table.put_item(Item={
        "ip": ip,
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "country": country or "Unknown",
        "city": city or "Unknown",
        "isp": isp or "Unknown",
    })

def view_logs():
    resp = table.scan()
    items = resp.get("Items", [])
    return sorted(items, key=lambda x: x.get("timestamp", ""), reverse=True)

def purge_logs():
    resp = table.scan()
    items = resp.get("Items", [])

    with table.batch_writer() as batch:
        for item in items:
            batch.delete_item(Key={"ip": item["ip"]})

    return len(items)
