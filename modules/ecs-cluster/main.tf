# modules/ecs-cluster/main.tf
# This module creates an ECS Cluster.
# It is now focused purely on the 'aws_ecs_cluster' resource.
# Networking, compute (ASG/ALB), and security groups are handled by
# other modules (e.g., 'full-ecs-environment' or called directly).

resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster-${var.project_name}-${var.environment}"

  tags = {
    Name        = "ecs-cluster-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}