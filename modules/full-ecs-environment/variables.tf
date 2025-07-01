# modules/full-ecs-environment/variables.tf
variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the ECS cluster to create."
  type        = string
}

# Optional variables for EC2 launch type (uncomment if needed)
/*
variable "ecs_instance_type" {
  description = "The EC2 instance type for ECS container instances."
  type        = string
  default     = "t3.medium"
}

variable "ecs_desired_capacity" {
  description = "The desired number of ECS container instances in the ASG."
  type        = number
  default     = 1
}

variable "ecs_max_size" {
  description = "The maximum number of ECS container instances in the ASG."
  type        = number
  default     = 3
}

variable "ecs_min_size" {
  description = "The minimum number of ECS container instances in the ASG."
  type        = number
  default     = 1
}

variable "key_pair_name" {
  description = "The name of the EC2 Key Pair to use for ECS container instances."
  type        = string
  default     = "" # Provide a default or make it required if using EC2
}
*/