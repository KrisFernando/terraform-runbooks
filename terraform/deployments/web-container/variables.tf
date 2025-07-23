# modules/cluster/variables.tf
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