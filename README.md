# StartTech Full-Stack Application

Senior DevOps Assessment - CI/CD Pipeline Implementation.

## 🚀 Quick Start
1. **Infrastructure**: Deploy the AWS resources using the `starttech-infra` repository first.
2. **Secrets**: Ensure `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET_NAME`, and `MONGO_URI` are added to GitHub Secrets.
3. **Deploy**: Push to the `main` branch to trigger the automated CI/CD pipelines.

## 📁 Repository Structure
- `backend/`: Golang API (Gin Gonic) following Clean Architecture.
- `frontend/`: React application built with Vite and TypeScript.
- `scripts/`: Operational scripts for health checks and rollbacks.
- `.github/workflows/`: Automation logic for multi-cloud deployment.

## 🛠 Tech Stack
- **Language**: Golang 1.21, TypeScript
- **Cloud**: AWS (EC2, S3, CloudFront, ALB, ElastiCache)
- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **Database**: MongoDB Atlas

## 📋 Operational Commands
- **Health Check**: `./scripts/health-check.sh <ALB_URL>`
- **Rollback**: `./scripts/rollback.sh`

## 👨‍💻 Author
[Eze Paul C]
