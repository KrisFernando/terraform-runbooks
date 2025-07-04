# modules/iam/github-oidc-role/variables.tf
variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "project_name" {
  description = "The name of the Project."
  type        = string
}

variable "github_organization" {
  description = "The GitHub organization name (e.g., 'my-company')."
  type        = string
}

variable "github_repository" {
  description = "The GitHub repository name (e.g., 'my-app')."
  type        = string
}

variable "policy_statements" {
  description = "A list of IAM policy statements to attach to the role."
  type        = list(any) # Use 'any' to allow flexible policy structures
  default     = []
}