# modules/security-group/main.tf
# This module defines reusable security groups for various components.

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${var.project_name}-${var.environment}"
  description = "Security group for Application Load Balancers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
    description = "Allow HTTP from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "alb-sg-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs-task-sg-${var.project_name}-${var.environment}"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  # Allow inbound from ALB
  ingress {
    from_port       = 80 # Or the container port your app listens on
    to_port         = 80 # Or the container port your app listens on
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Only allow traffic from the ALB SG
    description     = "Allow traffic from ALB"
  }

  # Allow outbound to internet (e.g., for pulling images, accessing external services)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "ecs-task-sg-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}