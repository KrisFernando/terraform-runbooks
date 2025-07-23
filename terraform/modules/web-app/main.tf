# modules/application/web-app-1/main.tf
# This module defines the resources for a specific web application,
# including ECR, ECS Task Definition, ECS Service, and an ALB.

# ECR Repository for the application images
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.environment}/${var.app_name}" # e.g., non-prod/web-app-1
  image_tag_mutability = "MUTABLE" # Or IMMUTABLE for production best practices

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.environment
  }
}

# IAM Role for ECS Task Execution (Fargate requires this for logging, ECR pull, etc.)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecs-task-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Role for ECS Task (if your application needs AWS permissions, e.g., S3 access)
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.app_name}-ecs-task-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach policies to ecs_task_role as needed (e.g., S3 read-only, DynamoDB access)
/*
resource "aws_iam_role_policy_attachment" "app_s3_read_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
*/

# ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.app_name}-${var.environment}"
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc" # Required for Fargate
  requires_compatibilities = ["FARGATE"] # Or ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn # Optional, if your app needs AWS permissions

  container_definitions = jsonencode([
    {
      name        = var.app_name
      image       = "${aws_ecr_repository.app_repo.repository_url}:${var.image_tag}"
      cpu         = var.cpu
      memory      = var.memory
      essential   = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = var.container_environment_variables # Pass environment variables
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-${var.environment}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.app_name}-task-def"
    Environment = var.environment
  }
}

# CloudWatch Log Group for ECS tasks
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = 7 # Adjust as needed

  tags = {
    Name        = "${var.app_name}-log-group"
    Environment = var.environment
  }
}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false # Public-facing ALB for websites
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id] # Security group for ALB
  subnets            = var.public_subnet_ids # ALB needs to be in public subnets

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.environment
  }
}

# ALB Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.app_name}-${var.environment}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # For Fargate

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.app_name}-tg"
    Environment = var.environment
  }
}

# ALB Listener (HTTP on port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.app_name}-alb-listener-http"
    Environment = var.environment
  }
}

# ECS Service
resource "aws_ecs_service" "app_service" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE" # Or "EC2"

  network_configuration {
    subnets         = var.private_subnet_ids # Fargate tasks run in private subnets
    security_groups = [var.app_security_group_id] # SG for the ECS tasks
    assign_public_ip = false # Tasks should not have public IPs
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  # Optional: Deployment circuit breaker for better deployments
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # Optional: Deployment controller type
  deployment_controller {
    type = "ECS" # Or CODE_DEPLOY, EXTERNAL
  }

  tags = {
    Name        = "${var.app_name}-service"
    Environment = var.environment
  }

  # Ensure the service waits for the ALB and Target Group to be ready
  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy,
  ]
}