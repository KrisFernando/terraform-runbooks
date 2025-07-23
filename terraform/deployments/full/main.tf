# Define the AWS provider for this deployment.
# The region variable would be set via CLI, environment variable, or a .tfvars file.
provider "aws" {
  region = var.aws_region
}

# Configure the Terraform remote backend for state management.
# The bucket and key should be unique per environment/deployment.
terraform {
  backend "s3" {
    bucket         = "${var.state_file_bucket}" # Dynamic bucket name based on environment
    key            = "${project-name}/${var.environment}/${project-name}-tf-state-file.tfstate"
    region         = var.aws_region # State bucket region (can be different from resource region)
    encrypt        = true
    dynamodb_table = "${project-name}-tf-state-lock-db-${var.environment}" # Dynamic DynamoDB table
  }
}

# Deploy the full ECS environment (VPC, subnets, cluster, ASG, ALBs, security groups).
# This single module call sets up the core infrastructure for your ECS applications.
module "full_ecs_environment" {
  source = "../modules/full-ecs-environment"

  environment        = var.environment
  aws_region         = var.aws_region
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  cluster_name       = "${var.environment}-${project-name}"
  ecs_instance_type    = "t3.medium"
  ecs_desired_capacity = 2
  ecs_max_size         = 3
  ecs_min_size         = 1
}

# Deploy a specific web application within the created ECS environment.
module "web_app_1" {
  source = "../modules/application/web-app-1"

  app_name                     = "web-app-1"
  environment                  = var.environment
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
    { name = "DB_HOST", value = "your-${var.environment}-db.rds.amazonaws.com" }
  ]
}

# Deploy a specific API service within the created ECS environment.
module "api_service_1" {
  source = "../modules/application/api-service-1"

  app_name                     = "api-service-1"
  environment                  = var.environment
  aws_region                   = var.aws_region
  vpc_id                       = module.full_ecs_environment.vpc_id
  public_subnet_ids            = module.full_ecs_environment.public_subnet_ids
  private_subnet_ids           = module.full_ecs_environment.private_subnet_ids
  ecs_cluster_id               = module.full_ecs_environment.ecs_cluster_id
  ecs_cluster_name             = module.full_ecs_environment.ecs_cluster_name
  alb_security_group_id        = module.full_ecs_environment.alb_security_group_id
  app_security_group_id        = module.full_ecs_environment.ecs_task_security_group_id
  image_tag                    = "latest"
  desired_count                = 1
  container_port               = 8080
  health_check_path            = "/status"
  cpu                          = 512
  memory                       = 1024
  container_environment_variables = [
    { name = "APP_ENV", value = var.environment },
  ]
}

# Deploy GitHub OIDC role for CI/CD access (e.g., to push ECR images)
module "github_oidc_role" {
  source = "../modules/iam/github-oidc-role"

  environment          = var.environment
  project_name       = var.project_name
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