# StartTech Full-Stack Application

## 🌟 Overview
This repository contains the full-stack application for StartTech, featuring a Golang backend, React frontend, and a complete CI/CD automation suite. This project demonstrates a production-ready AWS architecture focused on scalability, security, and zero-downtime deployments.

## 🏗 System Architecture
Detailed documentation of the AWS components (ALB, ASG, CloudFront, S3, ElastiCache, MongoDB Atlas) can be found in [ARCHITECTURE.md](./ARCHITECTURE.md).

## 🚀 CI/CD Pipeline Implementation (Phase 2)
### Frontend Pipeline
- **Security**: Runs `npm audit` for dependency scanning.
- **Testing**: Executes unit tests prior to build.
- **Automation**: Syncs to **S3** and invalidates **CloudFront** cache automatically.

### Backend Pipeline
- **Security**: Performs **Trivy** vulnerability scanning on Docker images.
- **Delivery**: Pushes containerized app to **Amazon ECR**.
- **Deployment**: Executes a **Rolling Update** via ASG Instance Refresh.
- **Validation**: Automatically runs **Smoke Tests** using `health-check.sh` post-deployment.

## 🔐 Setup & Configuration
### Required GitHub Secrets
To run the pipelines, configure the following secrets in this repository:
- `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`: (e.g., `us-east-1`)
- `S3_BUCKET_NAME`: Target bucket for React assets.
- `CLOUDFRONT_DIST_ID`: For cache invalidation.
- `ALB_DNS`: DNS name of the Backend Load Balancer.
- `MONGO_URI`: Connection string for MongoDB Atlas (Whitelist `0.0.0.0/0`).
- `REDIS_URL`: Endpoint for ElastiCache Redis.

## 📁 Repository Structure
- `backend/`: Golang API using Gin Gonic. Health endpoint at `/health`.
- `frontend/`: React + Vite application.
- `scripts/`:
  - `health-check.sh`: Automated retry-based health verification.
  - `deploy-backend.sh` / `deploy-frontend.sh`: Core deployment logic.
  - `rollback.sh`: Infrastructure-level rollback script.
- `.github/workflows/`: YAML definitions for GitHub Actions.

## 📋 Operations
Refer to the [RUNBOOK.md](./RUNBOOK.md) for detailed incident response, CloudWatch Log Insight queries, and scaling procedures.

## 👨‍💻 Author
**Eze Paul C** - Senior DevOps Engineer.
