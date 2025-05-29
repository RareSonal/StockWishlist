resource "aws_cognito_user_pool" "user_pool" {
  name = "stockwishlist-user-pool"  
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name           = "stockwishlist-client"
  user_pool_id   = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}
