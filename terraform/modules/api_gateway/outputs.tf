output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}"
}

output "proxy_resource_id" {
  value = aws_api_gateway_resource.v1_proxy.id
}

output "login_resource_id" {
  value = aws_api_gateway_resource.login.id
}

output "stocks_resource_id" {
  value = aws_api_gateway_resource.stocks.id
}

output "wishlist_resource_id" {
  value = aws_api_gateway_resource.wishlist.id
}
