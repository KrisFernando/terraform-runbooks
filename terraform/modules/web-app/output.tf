# modules/application/web-app-1/outputs.tf
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer for the web app."
  value       = aws_lb.app_alb.dns_name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository for the web app's images."
  value       = aws_ecr_repository.app_repo.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository for the web app's images."
  value       = aws_ecr_repository.app_repo.arn
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service for the web app."
  value       = aws_ecs_service.app_service.arn
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition for the web app."
  value       = aws_ecs_task_definition.app_task.arn
}