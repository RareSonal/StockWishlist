
output "rds_endpoint" {
  value = module.rds.endpoint
}

output "api_url" {
  value = module.api_gateway.api_url
}

output "amplify_console_url" {
  value = module.amplify.amplify_console_url
}

output "ssm_db_username" {
  value     = module.ssm_parameters.ssm_db_username
  sensitive = true
}

output "user_migration_lambda_arn" {
  value = module.lambda.user_migration_lambda_arn
}

output "lambda_arn" {
  value = module.lambda.lambda_invoke_arn
}

output "cognito_user_pool_id" {
  value = module.cognito.user_pool_id
}

output "cognito_client_id" {
  value = module.cognito.client_id
}

output "root_resource_id" {
  value = module.api_gateway.root_resource_id
}

output "cors_root_method_id" {
  value = module.cors_root.method_id
}

output "cors_login_method_id" {
  value = module.cors_login.method_id
}

output "cors_stocks_method_id" {
  value = module.cors_stocks.method_id
}

output "cors_wishlist_method_id" {
  value = module.cors_wishlist.method_id
}

output "cors_v1_proxy_method_id" {
  value = module.cors_v1_proxy.method_id
}
