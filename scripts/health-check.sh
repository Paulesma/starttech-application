#!/bin/bash
ALB_URL=$1
echo "Checking health at $ALB_URL/ping..."
curl -f "http://$ALB_URL/ping" || exit 1
