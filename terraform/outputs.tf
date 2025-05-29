output "rds_endpoint" {
  value = module.rds.rds_endpoint
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
  value = module.lambda.lambda_arn
}
