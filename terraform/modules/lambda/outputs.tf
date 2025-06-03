output "lambda_invoke_arn" {
  description = "Invoke ARN for the Flask backend Lambda function (used by API Gateway)"
  value       = aws_lambda_function.flask_backend.invoke_arn
}

output "lambda_function_name" {
  description = "Name of the Flask backend Lambda function"
  value       = aws_lambda_function.flask_backend.function_name
}

output "user_migration_lambda_arn" {
  description = "Raw ARN for the user migration Lambda function (used by Cognito)"
  value       = aws_lambda_function.user_migration.arn
}

output "user_migration_lambda_name" {
  description = "Name of the user migration Lambda function"
  value       = aws_lambda_function.user_migration.function_name
}
