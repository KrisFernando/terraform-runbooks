# modules/compute/asg-alb/main.tf
# This module creates an Application Load Balancer (ALB) and an Auto Scaling Group (ASG)
# for EC2 instances, typically used for hosting applications that are not ECS Fargate tasks.

# Application Load Balancer
resource "aws_lb" "main_alb" {
  name               = "alb-${var.project_name}-${var.environment}"
  internal           = var.alb_internal # True for internal ALB, false for public
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.subnet_ids # Can be public or private depending on 'internal' setting

  tags = {
    Name        = "alb-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}

# ALB Target Group
resource "aws_lb_target_group" "main_tg" {
  name        = "alb-tg-${var.project_name}-${var.environment}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance" # For EC2 instances

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
    Name        = "alb-tg-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}

# ALB Listener (HTTP on port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.main_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "alb-listener-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}

# IAM Role for EC2 instances (if needed for AWS service access)
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2-role-${var.project_name}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-profile-${var.project_name}-${var.environment}"
  role = aws_iam_role.ec2_instance_role.name
}

# Data source to get the latest Amazon Linux 2023 AMI with ECS Compatability
data "aws_ami" "amazon_linux_2023_ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-*-x86_64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "main_lt" {
  name_prefix   = "asg-lt-${var.project_name}-${var.environment}"
  image_id      = data.aws_ami.amazon_linux_2023_ecs.id
  instance_type = var.instance_type

  vpc_security_group_ids = var.instance_security_group_ids

/*
  # Example user data script to install Nginx
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<h1>Hello from ${var.environment} ${var.project_name}</h1>" | sudo tee /usr/share/nginx/html/index.html
  EOF
  )
*/

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "ec2-${var.project_name}-${var.environment}"
      Environment = var.environment
    }
  }

  tags = {
    Environment = var.environment
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "main_asg" {
  name                 = "asg-${var.project_name}-${var.environment}"
  vpc_zone_identifier  = var.subnet_ids
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  health_check_type    = "ELB" # Use ELB health checks
  target_group_arns    = [aws_lb_target_group.main_tg.arn]
  termination_policies = ["Default"]

  launch_template {
    id      = aws_launch_template.main_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  # Ensure ASG is created after ALB and its listener
  depends_on = [
    aws_lb_listener.http,
    aws_iam_instance_profile.ec2_instance_profile
  ]
}