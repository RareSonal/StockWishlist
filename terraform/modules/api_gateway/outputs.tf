output "api_url" {
  value = aws_api_gateway_stage.api_stage.invoke_url
}

output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "proxy_resource_id" {
  value = aws_api_gateway_resource.v1_proxy.id
}
