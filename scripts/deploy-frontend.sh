#!/bin/bash
# Usage: ./scripts/deploy-frontend.sh <S3_BUCKET_NAME>
BUCKET_NAME=$1

echo "📦 Installing frontend dependencies..."
cd frontend && npm install

echo "🏗️ Building production bundle..."
npm run build

echo "🚀 Syncing to S3 bucket: $BUCKET_NAME..."
# Vite builds to 'dist', standard React builds to 'build'
aws s3 sync dist/ s3://$BUCKET_NAME --delete

echo "✅ Frontend deployment complete!"
