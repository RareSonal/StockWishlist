output "api_url" {
  value = aws_api_gateway_stage.api_stage.invoke_url
}

output "api_id" {
  value = aws_api_gateway_rest_api.api.id
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
