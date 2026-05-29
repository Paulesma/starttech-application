# Operations Runbook - StartTech Full-Stack

This document provides operational procedures for maintaining, troubleshooting, and recovering the StartTech application environment.

## 🚨 Incident Response & Troubleshooting

### 1. Application is Unhealthy (ALB 502/504 / Target Group 'Unhealthy')
If the ALB reports targets are unhealthy, follow these steps in order:
1. **Check Target Group Status**: Go to **EC2 > Target Groups > backend-tg**. View "Health status details" to see if the error is a `Timeout` (Network/SG issue) or a `404/503` (App issue).
2. **Verify Database Connectivity**:
   - Confirm MongoDB Atlas Network Access allows `0.0.0.0/0`.
   - Ensure the `MONGO_URI` secret in GitHub/EC2 environment is correct.
3. **Container Logs**: SSH into an instance or use SSM Session Manager and run:
   ```bash
   docker ps -a
   docker logs backend
   ```
4. **Security Group Audit**: Verify `backend-ec2-sg` allows port `8080` inbound from `alb-sg`.

### 2. Rolling Back a Bad Deployment
If a deployment passes CI but fails in production (e.g., performance issues or hidden bugs):
1. **Trigger Manual Rollback**: Run the rollback script from the `scripts/` directory:
   ```bash
   ./scripts/rollback.sh terraform-20260525134202399700000004
   ```
2. **Verify**: This command reverts the ASG to use the previous stable Launch Template version. Check the ASG "Activity" tab to confirm new instances are launching.

## 📈 Monitoring & Log Analysis (Phase 3)

### 1. CloudWatch Log Insights
Application logs are centralized in the `/starttech/backend-logs` log group. Use the following queries for rapid analysis:

**Top Errors in last 1 hour:**
```sql
fields @timestamp, @message

| filter @message like /error/ or @message like /fatal/
| sort @timestamp desc
| limit 50
```

**Monitor Health Check Requests:**
```sql
fields @timestamp, @message

| filter @message like /GET \/health/
| stats count() by bin(1m)
```

### 2. CloudWatch Alarms
- **High CPU**: Triggered at 80% (Automatic Scaling via Target Tracking).
- **ALB 5XX Errors**: Critical alarm if 5XX errors exceed 5 in a 1-minute window.

## 🔐 Secrets & Configuration Management

### Rotating Secrets
To update the `MONGO_URI`, `REDIS_URL`, or `JWT_SECRET`:
1. Update the value in **GitHub Actions Secrets**.
2. Manually trigger the **Backend CI/CD** workflow via the "Workflow Dispatch" button in GitHub Actions.
3. The pipeline will automatically build the new config into the Launch Template and perform a rolling update of the instances.

## 🛠 Manual Scaling & Maintenance
- **Emergency Scale-up**: If the app is under heavy load and scaling is too slow:
  ```bash
  aws autoscaling update-auto-scaling-group --auto-scaling-group-name <ASG_NAME> --desired-capacity 4
  ```
- **Force Cache Clear**: To manually clear the global CDN cache:
  ```bash
  aws cloudfront create-invalidation --distribution-id <DIST_ID> --paths "/*"
  ```
