# modules/ecs-cluster/variables.tf
variable "project_name" {
  description = "The name of the Project."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}