#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io unzip curl jq

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

get_latest_tag() {
  local repo_name=$1
  aws ecr describe-images \
    --repository-name "$repo_name" \
    --region ${AWS_REGION} \
    --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' \
    --output text 2>/dev/null || echo "latest"
}

echo "Fetching latest image tags from ECR..."
BACKEND_TAG=$(get_latest_tag "${PROJECT_NAME}-backend")
FRONTEND_TAG=$(get_latest_tag "${PROJECT_NAME}-frontend")

echo "Backend tag: $BACKEND_TAG"
echo "Frontend tag: $FRONTEND_TAG"

cat <<EOF > /home/ubuntu/docker-compose.yml
services:
  backend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-backend:$BACKEND_TAG
    ports:
      - "8080:8080"
    environment:
      AWS_REGION: eu-west-1
      AWS_DEFAULT_REGION: eu-west-1

  frontend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-frontend:$FRONTEND_TAG
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