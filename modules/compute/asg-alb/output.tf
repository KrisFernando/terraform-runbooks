# modules/compute/asg-alb/outputs.tf
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.main_alb.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer."
  value       = aws_lb.main_alb.arn
}

output "target_group_arn" {
  description = "The ARN of the ALB Target Group."
  value       = aws_lb_target_group.main_tg.arn
}

output "asg_name" {
  description = "The name of the Auto Scaling Group."
  value       = aws_autoscaling_group.main_asg.name
}

output "asg_arn" {
  description = "The ARN of the Auto Scaling Group."
  value       = aws_autoscaling_group.main_asg.arn
}