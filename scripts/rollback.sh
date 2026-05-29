#!/bin/bash
# Usage: ./scripts/rollback.sh [ASG_NAME]

# Use the provided argument, or fall back to your specific ASG name
ASG_NAME=${1:-"terraform-20260525134202399700000004"}

echo "🔄 Initiating rollback for: $ASG_NAME..."

# Senior tip: rollback-instance-refresh reverts the ASG to the previous 
# Launch Template version automatically.
aws autoscaling rollback-instance-refresh --auto-scaling-group-name "$ASG_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Rollback initiated successfully."
else
    echo "❌ Rollback failed. Check if an instance refresh is currently in progress."
    exit 1
fi
