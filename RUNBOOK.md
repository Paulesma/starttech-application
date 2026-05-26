# Operations Runbook - StartTech

## 🚨 Incident Response
### App is Unhealthy (ALB 502/504)
1. Check CloudWatch Logs for Go panic errors: `/starttech/backend-logs`
2. Verify MongoDB Atlas IP Whitelist (ensure `0.0.0.0/0` or EC2 IPs are allowed).
3. Check Redis connectivity using `redis-cli` from an EC2 instance.

### Rolling Back a Bad Deployment
If a new code push breaks the site, run the following from your local terminal:
```bash
./scripts/rollback.sh
```

## 🔐 Secrets Management
To rotate API keys:
1. Update the secret in **GitHub Actions Secrets**.
2. Trigger a manual "Re-run" of the latest GitHub Action to redeploy with new values.

## 📈 Monitoring
Access the **CloudWatch Dashboard** in the AWS Console to view:
- CPU Utilization (Target < 80%)
- Request Count (ALB)
- 4xx/5xx Error Rates
