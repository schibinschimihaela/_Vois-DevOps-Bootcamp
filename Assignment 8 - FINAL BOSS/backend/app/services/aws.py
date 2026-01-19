import os
import boto3


def aws_status():
    region = os.getenv("AWS_REGION")
    sts = boto3.client("sts", region_name=region)
    ident = sts.get_caller_identity()

    return {"region": region, "account": ident.get("Account"), "arn": ident.get("Arn")}
