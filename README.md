# Deploy 3-Tier App on EKS

Production-ready 3-tier application deployed on Amazon EKS using GitOps principles.

## Architecture

User traffic flows through an AWS Load Balancer into an EKS cluster running three tiers: a Node.js frontend on port 3000, a Node.js REST API backend on port 5000, and a PostgreSQL 15 database as a StatefulSet with persistent storage.

## Stack

- Docker: Multi-stage builds with non-root users and healthchecks
- Terraform: Provisions EKS 1.29, VPC across 3 AZs, and ECR repositories
- GitHub Actions: Test, Trivy scan, build, push, and deploy pipeline
- ArgoCD: GitOps with auto-sync, self-heal, and pruning
- Prometheus and Grafana: Metrics collection and dashboards with Slack alerting
- Kubernetes: Deployments, HPA, StatefulSet, ConfigMaps, and Secrets

## Quick Start

Local development with docker-compose up --build gives you frontend on port 3000, backend on port 5000, and PostgreSQL on port 5432.

For EKS deployment, run terraform init and terraform apply from the terraform directory, then run scripts/bootstrap.sh to install ArgoCD and the monitoring stack.

## GitHub Secrets Required

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_ACCOUNT_ID
- AWS_REGION
- ARGOCD_TOKEN
- ARGOCD_SERVER
