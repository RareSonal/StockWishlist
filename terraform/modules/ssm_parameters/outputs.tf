output "db_username" {
  value     = aws_ssm_parameter.db_username.value
  sensitive = true
}
