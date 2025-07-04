# modules/security-group/variables.tf
variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "project_name" {
  description = "The name of the Project."
  type        = string
}
