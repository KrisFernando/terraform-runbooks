# modules/cluster/variables.tf
variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default = [ "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default = [ "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24" ]  
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable "project_name" {
  description = "The name of the Project."
  type        = string
  default = "product-a"
}

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