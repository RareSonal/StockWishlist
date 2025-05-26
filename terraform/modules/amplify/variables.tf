variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth token to access the repository"
}

variable "repository_url" {
  type        = string
  description = "GitHub repository URL"
}

variable "region" {
  type        = string
  default     = "us-east-1"
}

variable "api_url" {
  type        = string
  description = "API Gateway endpoint URL"
}

variable "cognito_user_pool_id" {
  type        = string
}

variable "cognito_client_id" {
  type        = string
}
