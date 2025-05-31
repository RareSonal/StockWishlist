resource "aws_cognito_user_pool" "user_pool" {
  name = "stockwishlist-user-pool"

  lambda_config {
    user_migration = var.user_migration_lambda_arn
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name            = "stockwishlist-client"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "allow_cognito_invoke" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = var.user_migration_lambda_arn
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.user_pool.id}"
}
