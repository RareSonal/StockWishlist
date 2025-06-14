variable "subnet_ids" {
  description = "List of subnet IDs for Lambda VPC configuration"
  type        = list(string)
}

variable "lambda_sg_id" {
  description = "Security Group ID for the Lambda function"
  type        = string
}

variable "db_host" {
  description = "Database host address"
  type        = string
}

variable "db_username" {
  description = "Username for connecting to the database"
  type        = string
}

variable "db_password" {
  description = "Password for connecting to the database"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "stockwishlist"
}

variable "db_port" {
  description = "Port for connecting to the database"
  type        = string
  default     = "5432"
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID for user migration Lambda environment"
  type        = string
}
