variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool for authorizing API Gateway requests"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN of the Lambda function to be invoked by API Gateway"
  type        = string
}

variable "stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "prod"
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch log group for API Gateway access logs"
  type        = string
}

variable "region" {
  description = "AWS region where resources are deployed"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function to invoke from API Gateway"
  type        = string
}

variable "cors_integration_ids" {
  description = "List of API Gateway integration IDs for CORS OPTIONS methods; used to create deployment dependencies"
  type        = list(string)
  default     = []
}

variable "include_cors" {
  description = "Flag to include CORS integrations as deployment triggers"
  type        = bool
  default     = false
}
