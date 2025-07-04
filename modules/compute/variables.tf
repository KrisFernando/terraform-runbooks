# modules/compute/asg-alb/variables.tf
variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the ALB and ASG instances will be launched."
  type        = list(string)
}

variable "project_name" {
  description = "The name of the Project."
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the security group to attach to the ALB."
  type        = string
}

variable "instance_security_group_ids" {
  description = "A list of security group IDs to attach to the EC2 instances in the ASG."
  type        = list(string)
}

variable "instance_type" {
  description = "The EC2 instance type for the Auto Scaling Group."
  type        = string
}

variable "desired_capacity" {
  description = "The desired number of EC2 instances in the Auto Scaling Group."
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 instances in the Auto Scaling Group."
  type        = number
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the Auto Scaling Group."
  type        = number
}

variable "health_check_path" {
  description = "The path for the ALB health check."
  type        = string
  default     = "/"
}

variable "container_port" {
  description = "The port on the EC2 instances that the application listens on."
  type        = number
  default     = 80
}

variable "alb_internal" {
  description = "Set to true to create an internal ALB, false for internet-facing."
  type        = bool
  default     = false
}