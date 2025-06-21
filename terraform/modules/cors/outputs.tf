output "options_integration_id" {
  value = aws_api_gateway_integration_response.options_integration_response[0].id
}

output "method_id" {
  value = try(aws_api_gateway_method.options[0].id, null)
}

