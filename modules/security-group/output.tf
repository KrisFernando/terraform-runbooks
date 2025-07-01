# modules/security-group/outputs.tf
output "alb_security_group_id" {
  description = "The ID of the ALB security group."
  value       = aws_security_group.alb_sg.id
}

output "ecs_task_security_group_id" {
  description = "The ID of the ECS task security group."
  value       = aws_security_group.ecs_task_sg.id
}

/*
output "rds_security_group_id" {
  description = "The ID of the RDS security group."
  value       = aws_security_group.rds_sg.id
}
*/