output "endpoint" {
  value = aws_db_instance.postgres_instance.address
}

output "rds_identifier" {
  value = aws_db_instance.postgres_instance.identifier
}
