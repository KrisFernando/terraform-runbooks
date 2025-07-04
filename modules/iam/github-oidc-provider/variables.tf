# modules/iam/github-oidc-role/variables.tf
variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "project_name" {
  description = "The name of the Project."
  type        = string
}