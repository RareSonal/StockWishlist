

output "api_id" {
  description = "The ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_url" {
  description = "Base invoke URL of the deployed API"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}"
}

output "proxy_resource_id" {
  description = "Resource ID for /v1/{proxy+}"
  value       = aws_api_gateway_resource.v1_proxy.id
}

output "login_resource_id" {
  description = "Resource ID for /v1/login"
  value       = aws_api_gateway_resource.login.id
}

output "stocks_resource_id" {
  description = "Resource ID for /v1/stocks"
  value       = aws_api_gateway_resource.stocks.id
}

output "wishlist_resource_id" {
  description = "Resource ID for /v1/wishlist"
  value       = aws_api_gateway_resource.wishlist.id
}

output "root_resource_id" {
  description = "Resource ID for root path /"
  value       = aws_api_gateway_rest_api.api.root_resource_id
}

output "deployment_id" {
  description = "Deployment ID of the API Gateway"
  value       = aws_api_gateway_deployment.api_deployment.id
}

output "stage_name" {
  description = "Stage name used in deployment"
  value       = aws_api_gateway_stage.api_stage.stage_name
}

output "cors_root_options_integration_response_id" {
  description = "Integration Response ID for CORS OPTIONS method on root resource"
  value       = module.cors_root.options_integration_response_id
}

output "cors_v1_proxy_options_integration_response_id" {
  description = "Integration Response ID for CORS OPTIONS method on /v1/{proxy+} resource"
  value       = module.cors_v1_proxy.options_integration_response_id
}

output "cors_login_options_integration_response_id" {
  description = "Integration Response ID for CORS OPTIONS method on /v1/login resource"
  value       = module.cors_login.options_integration_response_id
}

output "cors_stocks_options_integration_response_id" {
  description = "Integration Response ID for CORS OPTIONS method on /v1/stocks resource"
  value       = module.cors_stocks.options_integration_response_id
}

output "cors_wishlist_options_integration_response_id" {
  description = "Integration Response ID for CORS OPTIONS method on /v1/wishlist resource"
  value       = module.cors_wishlist.options_integration_response_id
}
