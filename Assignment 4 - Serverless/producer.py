import os
import json
import time
import uuid
import boto3
from datetime import datetime

sqs = boto3.client("sqs")
QUEUE_URL = os.environ["QUEUE_URL"]

TASKS = [
    "Buy groceries",
    "Prepare presentation",
    "Send weekly report",
    "Clean workspace",
    "Plan next sprint"
]

def handler(event, context):
    now = int(time.time())

    for i in range(3):
        payload = {
            "todoId": str(uuid.uuid4()),
            "title": TASKS[i % len(TASKS)],
            "status": "pending",
            "createdAt": now,
            "createdAtHuman": datetime.utcnow().isoformat() + "Z"
        }

        sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(payload)
        )

    return {
        "message": "3 todo items generated",
        "timestamp": now
    }
