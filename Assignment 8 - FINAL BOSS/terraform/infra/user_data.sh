#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io unzip curl

systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Install Docker Compose v2
curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
./aws/install

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} \
  | docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Create docker-compose.yml
cat <<EOF > /home/ubuntu/docker-compose.yml
version: "3.8"

services:
  backend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/ip-spectre-backend:latest
    ports:
      - "8080:8080"

  frontend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/ip-spectre-frontend:latest
    ports:
      - "80:80"
    depends_on:
      - backend
EOF

chown ubuntu:ubuntu /home/ubuntu/docker-compose.yml
cd /home/ubuntu

sleep 30
docker compose pull
docker compose up -d
