import os
import json
import time
import uuid
import boto3

dynamodb = boto3.resource("dynamodb")
TABLE = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    records = event.get("Records", [])
    print(f"[worker] received {len(records)} message(s)")

    stored = 0
    skipped = 0

    for record in records:
        body = record.get("body", "")

        try:
            item = json.loads(body)
        except Exception as e:
            print(f"[worker] invalid JSON, skipping message: {str(e)}")
            skipped += 1
            continue

        now = int(time.time())

        item["todoId"] = item.get("todoId") or str(uuid.uuid4())
        item["title"] = (item.get("title") or "Untitled task").strip()
        item["status"] = item.get("status") or "pending"
        item["createdAt"] = int(item.get("createdAt") or now)

        try:
            TABLE.put_item(Item=item)
            stored += 1
            print(f"[worker] stored todoId={item['todoId']} title='{item['title']}'")
        except Exception as e:
            print(f"[worker] ERROR storing item: {str(e)}")
            raise

    return {
        "received": len(records),
        "stored": stored,
        "skipped": skipped
    }
