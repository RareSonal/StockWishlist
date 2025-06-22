output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.endpoint
}

output "api_url" {
  description = "Base URL of the deployed API Gateway"
  value       = module.api_gateway.api_url
}

output "amplify_console_url" {
  description = "URL of the Amplify Console deployment"
  value       = module.amplify.amplify_console_url
}

output "ssm_db_username" {
  description = "Database username stored in SSM Parameter Store"
  value       = module.ssm_parameters.ssm_db_username
  sensitive   = true
}

output "user_migration_lambda_arn" {
  description = "ARN of the User Migration Lambda function"
  value       = module.lambda.user_migration_lambda_arn
}

output "lambda_arn" {
  description = "Invoke ARN of the main Lambda function"
  value       = module.lambda.lambda_invoke_arn
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.cognito.client_id
}

output "root_resource_id" {
  description = "API Gateway root resource ID"
  value       = module.api_gateway.root_resource_id
}

output "cors_root_method_id" {
  description = "ID of the CORS OPTIONS method for root resource"
  value       = module.cors_root.method_id
}

output "cors_root_options_integration_response_id" {
  description = "ID of the CORS OPTIONS integration response for root resource"
  value       = module.cors_root.options_integration_response_id
}

output "cors_v1_proxy_options_integration_response_id" {
  description = "ID of the CORS OPTIONS integration response for /v1/{proxy+}"
  value       = module.cors_v1_proxy.options_integration_response_id
}

output "cors_login_options_integration_response_id" {
  description = "ID of the CORS OPTIONS integration response for /v1/login"
  value       = module.cors_login.options_integration_response_id
}

output "cors_stocks_options_integration_response_id" {
  description = "ID of the CORS OPTIONS integration response for /v1/stocks"
  value       = module.cors_stocks.options_integration_response_id
}

output "cors_wishlist_options_integration_response_id" {
  description = "ID of the CORS OPTIONS integration response for /v1/wishlist"
  value       = module.cors_wishlist.options_integration_response_id
}
