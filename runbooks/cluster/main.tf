# modules/full-ecs-environment/main.tf
# This module orchestrates the deployment of a complete ECS environment,
# including VPC, subnets, internet gateway, NAT gateways, security groups,
# the ECS cluster itself, and optionally Auto Scaling Group/Load Balancer
# for EC2 container instances.

# Call the network module to set up VPC, subnets, etc.
module "network" {
  source = "../../modules/network" # Relative path to the network module

  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "ecs_container_asg_alb" {
  source = "../../modules/compute"

  environment          = var.environment
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.private_subnet_ids # Or public, depending on architecture
  alb_name             = "${var.environment}-ecs-container-alb"
  target_group_name    = "${var.environment}-ecs-container-tg"
  alb_security_group_id = module.common_security_groups.alb_security_group_id
  instance_security_group_ids = [module.common_security_groups.ecs_instance_sg_id] # Example SG output
  instance_type        = var.ecs_instance_type
  desired_capacity     = var.ecs_desired_capacity
  max_size             = var.ecs_max_size
  min_size             = var.ecs_min_size
  health_check_path    = "/ecs-health" # Health check for ECS agent
  container_port       = 80 # Or relevant port for ECS agent
}

# Call the security group module for common security groups.
module "common_security_groups" {
  source = "../../modules/security-group" # Relative path to the security-group module

  vpc_id      = module.network.vpc_id
  environment = var.environment
}

# Call the ECS cluster module to create the ECS cluster resource.
module "ecs_cluster" {
  source = "../../modules/ecs-cluster" # Relative path to the ecs-cluster module

  cluster_name = var.cluster_name
  environment  = var.environment
}