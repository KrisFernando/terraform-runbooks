# modules/application/web-app-1/variables.tf
variable "app_name" {
  description = "The name of the application (e.g., 'web-app-1')."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the application will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS tasks."
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster to deploy the service into."
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the security group for the Application Load Balancer."
  type        = string
}

variable "app_security_group_id" {
  description = "The ID of the security group for the ECS tasks."
  type        = string
}

variable "image_tag" {
  description = "The Docker image tag to deploy (e.g., 'latest', 'v1.0.0')."
  type        = string
}

variable "desired_count" {
  description = "The desired number of ECS tasks to run."
  type        = number
  default     = 1
}

variable "container_port" {
  description = "The port on the container that the application listens on."
  type        = number
}

variable "health_check_path" {
  description = "The path for the ALB health check for the application."
  type        = string
  default     = "/"
}

variable "cpu" {
  description = "The CPU units for the Fargate task (e.g., 256, 512, 1024)."
  type        = number
}

variable "memory" {
  description = "The memory (MiB) for the Fargate task (e.g., 512, 1024, 2048)."
  type        = number
}

variable "container_environment_variables" {
  description = "A list of environment variables to pass to the container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}