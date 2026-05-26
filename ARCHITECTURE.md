# System Architecture - StartTech Full-Stack

## Overview
This document outlines the cloud-native architecture for the StartTech application, designed for high availability, scalability, and automated delivery.

## Component Breakdown
1. **Frontend (React/Vite)**: 
   - Hosted as a static site on **AWS S3**.
   - Distributed globally via **CloudFront CDN** for low-latency delivery and HTTPS termination.
2. **Backend API (Golang)**:
   - Containerized with **Docker** using a multi-stage build for security and performance.
   - Deployed on **EC2 instances** managed by an **Auto Scaling Group (ASG)** across multiple Availability Zones.
   - Traffic is managed by an **Application Load Balancer (ALB)**.
3. **Data Layer**:
   - **MongoDB Atlas**: Managed NoSQL database for persistence.
   - **Redis (ElastiCache)**: Used for session management and database query caching.

## CI/CD Workflow
- **Infrastructure**: Managed via Terraform with state stored in an S3 backend.
- **Backend Pipeline**: GitHub Actions builds Docker images, pushes to **Amazon ECR**, and triggers an **ASG Instance Refresh** (Rolling Update).
- **Frontend Pipeline**: GitHub Actions builds the production bundle and syncs it to S3, followed by a CloudFront cache invalidation.

## Security
- **IAM**: Principle of Least Privilege applied to EC2 roles and GitHub Actions users.
- **Networking**: Private subnets for Redis; ALB and Security Groups restrict traffic to necessary ports only (80, 8080, 6379).
