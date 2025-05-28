variable "cognito_user_pool_arn" {
description = "ARN of the Cognito User Pool"
type = string
}

variable "subnet_ids" {
description = "List of subnet IDs for Lambda VPC configuration"
type = list(string)
}

variable "lambda_sg_id" {
description = "Security Group ID for the Lambda function"
type = string
}

variable "db_host" {
description = "Database host address"
type = string
}

variable "db_username" {
description = "Username for connecting to the database"
type = string
}

variable "db_password" {
description = "Password for connecting to the database"
type = string
}

variable "cognito_user_pool_id" {
description = "ID of the Cognito User Pool"
type = string
}

variable "cognito_client_id" {
description = "Cognito App Client ID"
type = string
}

variable "region" {
description = "AWS region to deploy resources"
type = string
default = "us-east-1"
}
