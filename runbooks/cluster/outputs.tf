# modules/full-ecs-environment/outputs.tf
output "vpc_id" {
  description = "The ID of the VPC created."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets."
  value       = module.network.private_subnet_ids
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster."
  value       = module.ecs_cluster.cluster_id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = module.ecs_cluster.cluster_name
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group."
  value       = module.common_security_groups.alb_security_group_id
}

output "ecs_task_security_group_id" {
  description = "The ID of the ECS task security group."
  value       = module.common_security_groups.ecs_task_security_group_id
}

output "github_provider_arn" {
  description = "The ARN of the GitHub OIDC provider."
  value = module.github_provider.github_provider_arn
}

/*
# If using EC2 launch type for ECS instances, uncomment these outputs:
output "ecs_container_asg_name" {
  description = "The name of the Auto Scaling Group for ECS container instances."
  value       = module.ecs_container_asg_alb.asg_name
}

output "ecs_container_alb_dns_name" {
  description = "The DNS name of the ALB for ECS container instances."
  value       = module.ecs_container_asg_alb.alb_dns_name
}
*/
