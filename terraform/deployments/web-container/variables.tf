# modules/web-app/variables.tf
variable "project_name" {
  description = "The name of the Project."
  type        = string
  default = "product-a"
}

variable "remote_state_bucket" {
  description = "Remote state Bucket Name."
  type        = string
  default = "tf-configuration-statefiles"  
}

variable "remote_state_key" {
  description = "Remote state Bucket Key."
  type        = string
  default = "cluster/cluster-tf-state-file.tfstate"  
}


variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default = "us-east-1"
}

variable "app_name" {
  description = "The name of the Application."
  type        = string
  default = "web-app"
}

variable "db_host" {
  description = "The host of the Database."
  type        = string
  default = "database-db.rds.amazonaws.com"
}

variable "db_port" {
  description = "The port of the Database."
  type        = number
  default = 3306
}