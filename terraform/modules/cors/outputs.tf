

output "options_integration_response_id" {
  description = "ID of the integration response for CORS OPTIONS method"
  value       = try(aws_api_gateway_integration_response.options_integration_response[0].id, null)
}

output "method_id" {
  description = "ID of the CORS OPTIONS method (if created)"
  value       = try(aws_api_gateway_method.options[0].id, null)
}
