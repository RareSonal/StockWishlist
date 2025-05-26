resource "aws_ssm_parameter" "github_oauth_token" {
  name  = "/stockwishlist/github_oauth_token"
  type  = "SecureString"
  value = var.github_oauth_token
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/stockwishlist/db_username"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/stockwishlist/db_password"
  type  = "SecureString"
  value = var.db_password
}
