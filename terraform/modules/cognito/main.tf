resource "aws_cognito_user_pool" "user_pool" {
  name = "stockwishlist-user-pool"

  lambda_config {
    user_migration = var.user_migration_lambda_arn
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "stockwishlist-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_AUTH"
  ]

  prevent_user_existence_errors = "LEGACY"

  access_token_validity  = 60    
  id_token_validity      = 60    
  refresh_token_validity = 30    

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  auth_session_validity = 3 
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "allow_cognito_invoke" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = split(":", var.user_migration_lambda_arn)[6] # Extract function name from full ARN
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.user_pool.id}"
}
