# Example variables for this environment (would typically be in a .tfvars file)
variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "us-east-1"
}

variable "state_file_bucket" {
  description = "AWS S3 Bucket for statefile."
  type = string
  default = "its-cloud-web-tf-state-bucket"
}

variable "project_name" {
  description = "The name of the Project."
  type        = string
  default = "product-a"
}

variable "terraform-state-lock-db" {
  description = "DynamoDB table to lock statetables."
  type = string
  default = "value"
}

variable "environment" {
  description = "The deployment environment (e.g., 'non-prod', 'prod')."
  type        = string
  default     = "non-prod" # Default for example, override with -var-file
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "github_organization" {
  description = "Your GitHub organization."
  type        = string
  default     = "your-github-org"
}

variable "github_repository" {
  description = "Your GitHub repository name."
  type        = string
  default     = "your-repo-name"
}
