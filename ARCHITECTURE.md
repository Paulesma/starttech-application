# System Architecture - StartTech Full-Stack

## Overview
This document outlines the cloud-native architecture for the StartTech application. The system is designed for high availability, automated scaling, and secure delivery using a hybrid cloud approach (AWS + MongoDB Atlas).

## Component Breakdown

### 1. Frontend (React/Vite)
- **Hosting**: Static assets are hosted on **Amazon S3** with public access blocked.
- **Distribution**: **Amazon CloudFront** serves as the CDN, providing global low-latency delivery and HTTPS termination. 
- **Origin Access**: Uses **Origin Access Control (OAC)** to ensure S3 content is only accessible via CloudFront.

### 2. Backend API (Golang)
- **Compute**: Containerized Golang application running on **EC2 instances**.
- **Orchestration**: Managed by an **Auto Scaling Group (ASG)** across multiple Availability Zones to ensure high availability.
- **Traffic Management**: An **Application Load Balancer (ALB)** distributes incoming traffic and performs health checks on the `/health` endpoint.

### 3. Data & Caching Layer
- **Database**: **MongoDB Atlas** (Managed Service) provides a scalable NoSQL backend.
- **Caching**: **Amazon ElastiCache (Redis)** manages sessions and caches frequent database queries to reduce latency.

## Networking & Security

### Network Isolation
- **Edge**: CloudFront handles global entry points.
- **Public Subnets**: Host the ALB and EC2 instances. 
  - *Note*: EC2 instances reside in public subnets with public IPs to facilitate outbound communication (ECR pulls, MongoDB connectivity) without the cost of a NAT Gateway.
- **Security Groups**: 
  - **ALB-SG**: Allows Inbound 80 (HTTP) from 0.0.0.0/0.
  - **EC2-SG**: Strictly allows Inbound 8080 **only** from the ALB-SG.
  - **Redis-SG**: Strictly allows Inbound 6379 from the EC2-SG.

### Identity & Access Management (IAM)
- **Instance Profile**: EC2 instances are assigned roles with `AmazonEC2ContainerRegistryReadOnly` (for Docker pulls) and `CloudWatchAgentServerPolicy` (for centralized logging).
- **CI/CD**: GitHub Actions uses a dedicated IAM user with scoped permissions to S3, ECR, and ECS.

## CI/CD Workflow

### Infrastructure as Code (IaC)
- **Terraform**: Entire stack (VPC, ALB, ASG, Redis, S3, CloudFront) is provisioned via modularized Terraform code.

### Deployment Pipelines
- **Frontend**: GitHub Actions runs `npm audit`, builds production assets, syncs to S3, and triggers a CloudFront invalidation.
- **Backend**: GitHub Actions runs `Trivy` security scans, builds Docker images, pushes to **Amazon ECR**, updates the **Launch Template**, and initiates an **ASG Instance Refresh** for zero-downtime rolling updates.

## Monitoring & Observability
- **Logs**: Application logs are streamed to **CloudWatch Logs** via the CloudWatch Agent.
- **Metrics**: ASG scaling is driven by **CloudWatch Alarms** tracking average CPU utilization (Target Tracking at 80%).
- **Health**: ALB performs active health monitoring; failures trigger automatic instance replacement.
