variable "use_public_subnet_for_rds" {
  type    = bool
  default = false
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the application"
  type        = string
}

# Database Configuration
variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "postgres"
}

variable "db_host" {
  description = "PostgreSQL endpoint/host"
  type        = string
}

variable "db_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

# AWS and GitHub
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for Terraform GitHub provider"
  type        = string
  sensitive   = true
}

# API Gateway
variable "api_stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "prod"
}

# Cognito
variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "cognito_app_client_id" {
  description = "Cognito App Client ID"
  type        = string
}
