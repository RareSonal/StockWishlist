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
