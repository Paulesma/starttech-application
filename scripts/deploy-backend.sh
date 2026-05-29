#!/bin/bash
# Usage: ./scripts/deploy-backend.sh <ECR_REPO_URL> <ASG_NAME>

ECR_REPO_URL=$1
ASG_NAME=$2
REGION="us-east-1"

if [ -z "$ECR_REPO_URL" ] || [ -z "$ASG_NAME" ]; then
    echo "❌ Error: Missing arguments."
    echo "Usage: ./scripts/deploy-backend.sh <ECR_REPO_URL> <ASG_NAME>"
    exit 1
fi

echo "🐳 Building Docker image..."
# Navigate to backend if script is run from root
cd "$(dirname "$0")/../backend" || exit 1
docker build -t starttech-backend:latest .

echo "🔑 Logging into Amazon ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "$(echo $ECR_REPO_URL | cut -d/ -f1)"

echo "📤 Pushing image to ECR..."
docker tag starttech-backend:latest "$ECR_REPO_URL:latest"
docker push "$ECR_REPO_URL:latest"

echo "🔄 Triggering ASG Instance Refresh (Rolling Update)..."
# The requirement asks for rolling updates; start-instance-refresh handles this in AWS.
aws autoscaling start-instance-refresh \
    --auto-scaling-group-name "$ASG_NAME" \
    --preferences '{"MinHealthyPercentage": 50}'

echo "⏳ Waiting for Refresh to start..."
sleep 10

echo "🚀 Backend deployment initiated successfully!"

# Phase 2 Requirement: Smoke Test
# We call the other script you wrote to verify the deployment
echo "🧪 Running Smoke Test..."
./scripts/health-check.sh
