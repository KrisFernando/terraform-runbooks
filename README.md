# Terraform Runbooks

## Cluster Deployment

- Network: VPC, Subnets, Route Tables, IGW, NAT, SG
- Cluster: ECS Cluster
- Compute: ALB, ASG, EC2
- Security: Security Group

## Static Website Deployment

- Compute: S3 Bucket with Static Web Hosting
- CDN: CloudFront
- SSL: Certificate Manager (Sectigo import)
- Security: IAM Role for GitHub (S3 & CloudFront)

## Dynamic Website Deployment

- Container Image: ECR Repository
- Versioning: ECS Task Definition
- Compute: ECS Service
- Security: Security Group, IAM Role for GitHub (ECR & ECS)

## API Deployment

- Container Image: ECR Repository
- Versioning: ECS Task Definition
- Compute: ECS Service
- Security: Security Group, IAM Role for GitHub (ECR & ECS)
