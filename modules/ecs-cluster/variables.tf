# modules/ecs-cluster/variables.tf
variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}