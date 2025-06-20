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
