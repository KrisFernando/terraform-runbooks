# runbooks/cluster/main.tf
# This module orchestrates the deployment of a complete ECS environment,
# including VPC, subnets, internet gateway, NAT gateways, security groups,
# the ECS cluster itself, and optionally Auto Scaling Group/Load Balancer
# for EC2 container instances.

# Define the AWS provider for this deployment.
# The region variable would be set via CLI, environment variable, or a .tfvars file.
provider "aws" {
  region = var.aws_region
}

# Configure the Terraform remote backend for state management.
# The bucket and key should be unique per environment/deployment.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0"
    }
  }
  required_version = "~> 1.12.2"

  backend "s3" {
    bucket         = "tf-statefiles-web-app-2025-07-26-xasdf" # Dynamic bucket name based on environment
    key            = "project-a/web-app-tf-state-file.tfstate"
    region         = "us-east-1" # State bucket region (can be different from resource region)
    encrypt        = true
    use_lockfile = true
  }
}

# Deploy a specific web application within the created ECS environment.
module "web_app" {
  source = "../modules/application/web-app-1"

  app_name                     = var.app_name
  environment                  = local.environment
  aws_region                   = var.aws_region
  vpc_id                       = local.vpc_id
  public_subnet_ids            = local.public_subnet_ids
  private_subnet_ids           = local.private_subnet_ids
  ecs_cluster_id               = local.cluster_id
  ecs_cluster_name             = local.ecs_cluster_name
  alb_security_group_id        = local.alb_security_group_id
  app_security_group_id        = local.ecs_task_security_group_id
  image_tag                    = "latest" # Or a specific version
  desired_count                = 1
  container_port               = 80
  health_check_path            = "/health"
  cpu                          = 256 # Fargate CPU units
  memory                       = 512 # Fargate Memory MiB
  container_environment_variables = [
    { name = "APP_ENV", value = local.environment },
    { name = "DB_HOST", value = var.db_host },
    { name = "DB_PORT", value = var.db_port }
  ]
}

# Deploy GitHub OIDC role for CI/CD access (e.g., to push ECR images)
module "github_oidc_role" {
  source = "git::https://github.com/sparx-general/terraform-github-oidc-iam-role-module.git?ref=v1.0.0"

  environment          = local.environment
  project_name         = var.project_name
  github_organization  = var.github_organization
  github_repository    = var.github_repository
  # Define specific permissions for this role, e.g., ECR push access
  policy_statements = [
    {
      sid    = "ECRPushAccess"
      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken"
      ]
      resources = [
        module.web_app_1.ecr_repository_arn,
        module.api_service_1.ecr_repository_arn
      ]
    }
  ]
}