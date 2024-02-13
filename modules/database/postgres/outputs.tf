output "endpoint" {
  description = "The connection endpoint in address:port format"
  value       = aws_db_instance.postgres_db.endpoint
}

output "jdbc_url" {
  description = "The jdbc url of the postgres instance"
  value       = "jdbc:postgresql://${aws_db_instance.postgres_db.endpoint}/${aws_db_instance.postgres_db.db_name}"
}

