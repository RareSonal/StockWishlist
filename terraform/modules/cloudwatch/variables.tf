variable "lambda_function_name" {
  type = string
}

variable "rds_identifier" {
  type = string
}

variable "api_name" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}
