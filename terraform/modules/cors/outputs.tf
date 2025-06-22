output "options_integration_response_id" {
  description = "ID of the integration response for CORS OPTIONS method"
  value       = length(aws_api_gateway_integration_response.options) > 0 ? aws_api_gateway_integration_response.options[0].id : ""
}

output "method_id" {
  description = "ID of the CORS OPTIONS method (if created)"
  value       = length(aws_api_gateway_method.options) > 0 ? aws_api_gateway_method.options[0].id : ""
}
