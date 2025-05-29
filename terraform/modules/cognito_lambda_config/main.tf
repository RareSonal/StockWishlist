resource "aws_cognito_user_pool_lambda_config" "config" {
  user_pool_id   = var.user_pool_id
  user_migration = var.user_migration_lambda_arn
}

resource "aws_lambda_permission" "allow_cognito_invoke" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = var.user_migration_lambda_arn
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.user_pool_id
}
