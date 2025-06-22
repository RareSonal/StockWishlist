
output "options_integration_id" {
  description = "Integration ID for the OPTIONS method"
  value       = try(aws_api_gateway_integration.options_mock[0].id, null)
}

output "method_id" {
  description = "Method ID for the OPTIONS method"
  value       = try(aws_api_gateway_method.options[0].id, null)
}
