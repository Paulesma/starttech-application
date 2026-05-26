#!/bin/bash
echo "Rolling back Backend Deployment..."
aws autoscaling rollback-instance-refresh --auto-scaling-group-name starttech-backend-asg
