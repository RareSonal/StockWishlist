output "user_pool_id" {
description = "ID of the Cognito User Pool"
value = aws_cognito_user_pool.user_pool.id
}

output "client_id" {
description = "ID of the Cognito App Client"
value = aws_cognito_user_pool_client.user_pool_client.id
}

output "user_pool_arn" {
description = "ARN of the Cognito User Pool"
value = aws_cognito_user_pool.user_pool.arn
}
