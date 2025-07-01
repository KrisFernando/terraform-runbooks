# modules/compute/ec2/variables.tf
variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
}

variable "instance_name" {
  description = "The name for the EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
}

variable "key_pair_name" {
  description = "The name of the EC2 Key Pair to use for the instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance into."
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to attach to the EC2 instance."
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = false
}

variable "ebs_volumes" {
  description = "A list of EBS volumes to attach to the instance."
  type = list(object({
    device_name         = string
    volume_size         = number
    volume_type         = string
    encrypted           = optional(bool, true)
    delete_on_termination = optional(bool, true)
  }))
  default = []
}