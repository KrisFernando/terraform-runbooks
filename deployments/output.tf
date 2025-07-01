# Output relevant information for the environment
output "vpc_id" {
  description = "The ID of the VPC created in this environment."
  value       = module.full_ecs_environment.vpc_id
}

output "web_app_1_alb_dns_name" {
  description = "The DNS name of the ALB for Web App 1."
  value       = module.web_app_1.alb_dns_name
}

output "api_service_1_alb_dns_name" {
  description = "The DNS name of the ALB for API Service 1."
  value       = module.api_service_1.alb_dns_name
}

output "github_oidc_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions OIDC."
  value       = module.github_oidc_role.role_arn
}