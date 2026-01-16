#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io unzip curl

systemctl start docker
systemctl enable docker

usermod -aG docker ubuntu

mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
./aws/install

cat <<EOF > /home/ubuntu/docker-compose.yml
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

su - ubuntu -c "aws ecr get-login-password --region ${AWS_REGION} \
  | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

su - ubuntu -c "cd /home/ubuntu && docker compose pull"
su - ubuntu -c "cd /home/ubuntu && docker compose up -d"
