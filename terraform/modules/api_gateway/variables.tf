variable "cognito_user_pool_arn" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "stage_name" {
  type    = string
  default = "prod"
}

variable "log_group_arn" {
  type = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function for API Gateway to invoke"
  type        = string
}
