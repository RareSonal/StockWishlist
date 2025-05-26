output "lambda_arn" {
  value = aws_lambda_function.flask_backend.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.flask_backend.function_name
}
