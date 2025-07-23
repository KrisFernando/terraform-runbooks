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
  vpc_id                       = module.full_ecs_environment.vpc_id
  public_subnet_ids            = module.full_ecs_environment.public_subnet_ids
  private_subnet_ids           = module.full_ecs_environment.private_subnet_ids
  ecs_cluster_id               = module.full_ecs_environment.ecs_cluster_id
  ecs_cluster_name             = module.full_ecs_environment.ecs_cluster_name
  alb_security_group_id        = module.full_ecs_environment.alb_security_group_id
  app_security_group_id        = module.full_ecs_environment.ecs_task_security_group_id
  image_tag                    = "latest" # Or a specific version
  desired_count                = 1
  container_port               = 80
  health_check_path            = "/health"
  cpu                          = 256 # Fargate CPU units
  memory                       = 512 # Fargate Memory MiB
  container_environment_variables = [
    { name = "APP_ENV", value = var.environment },
    { name = "DB_HOST", value = var.db_host },
    { name = "DB_PORT", value = var.db_port }
  ]
}