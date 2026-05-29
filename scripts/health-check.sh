#!/bin/bash
# Usage: ./scripts/health-check.sh <ALB_DNS_NAME>

ALB_URL=$1

if [ -z "$ALB_URL" ]; then
    echo "❌ Usage: ./health-check.sh <ALB_DNS_NAME>"
    exit 1
fi

echo "🔍 Starting Health Check for: http://$ALB_URL/health"

MAX_RETRIES=12
WAIT_SECONDS=5

for ((i=1; i<=MAX_RETRIES; i++)); do
    # Added || echo "000" to handle cases where curl itself exits with an error code
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://$ALB_URL/health" || echo "000")

    if [ "$STATUS" -eq 200 ]; then
        echo "✅ SUCCESS: Application is healthy (Status 200)"
        exit 0
    fi

    echo "⚠️ Attempt $i/$MAX_RETRIES: Received status $STATUS. Retrying in ${WAIT_SECONDS}s..."
    sleep $WAIT_SECONDS
done

echo "❌ FAILURE: Application failed health check after $MAX_RETRIES attempts."
exit 1
