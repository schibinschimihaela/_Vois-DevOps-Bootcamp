# Terraform – Episode 2
## Private EC2 Connectivity Using IaC

This folder contains the Terraform implementation of the
"Link Between the Nodes – Episode 2" assignment.

---

## What Was Provisioned

- VPC (`10.10.0.0/16`)
- Two private subnets in different AZs
- Security group allowing SSH only between subnets
- Two EC2 instances (`t3.micro`, Amazon Linux 2)
- No public IP addresses
- Remote backend using S3 and DynamoDB

---

## Backend Configuration

Terraform state is stored remotely to ensure consistency and locking.

![S3 Backend](photos/s3.png)  
![DynamoDB Lock](photos/dynamodb.png)

---

## SSH Connectivity Validation

Private SSH connectivity was successfully tested:

**NodeA → NodeB**
  
![NodeA to NodeB](photos/NodeA-NodeB.png)

**NodeB → NodeA**
  
![NodeB to NodeA](photos/NodeB-NodeA.png)

---

## Notes

Because instances are deployed in private subnets without public IPs,
an **EC2 Instance Connect Endpoint** was used to access NodeA
for validation purposes only.

---

## Cleanup

Resources were removed using:
```bash
terraform destroy
