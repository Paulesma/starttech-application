#!/bin/bash
# Usage: ./scripts/deploy-frontend.sh <S3_BUCKET_NAME> <CLOUDFRONT_DIST_ID>

BUCKET_NAME=$1
DIST_ID=$2

if [ -z "$BUCKET_NAME" ] || [ -z "$DIST_ID" ]; then
    echo "❌ Usage: ./scripts/deploy-frontend.sh <S3_BUCKET_NAME> <CLOUDFRONT_DIST_ID>"
    exit 1
fi

echo "📦 Installing frontend dependencies..."
cd "$(dirname "$0")/../frontend" || exit 1
npm install

echo "🏗️ Building production bundle..."
npm run build

echo "🚀 Syncing to S3 bucket: $BUCKET_NAME..."
# Vite projects build to 'dist', CRA builds to 'build'
# --delete ensures old, unused files are removed from S3
aws s3 sync dist/ s3://$BUCKET_NAME --delete

echo "🧹 Invalidating CloudFront cache..."
# '/*' invalidates the entire site so the new build shows immediately
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*"

echo "✅ Frontend deployment complete!"
