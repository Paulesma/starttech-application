#!/bin/bash
# Usage: ./scripts/deploy-backend.sh <ECR_REPO_URL> <ASG_NAME>
REPO_URL=$2
ASG_NAME=$3

echo "🐳 Building Docker image..."
cd backend
docker build -t starttech-backend:latest .

echo "🔑 Logging into Amazon ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_URL

echo "📤 Pushing image to ECR..."
docker tag starttech-backend:latest $REPO_URL:latest
docker push $REPO_URL:latest

echo "🔄 Triggering ASG Instance Refresh (Rolling Update)..."
aws autoscaling start-instance-refresh --auto-scaling-group-name $ASG_NAME

echo "✅ Backend deployment initiated!"
