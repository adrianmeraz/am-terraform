output "endpoint" {
  description = "The connection endpoint in address:port format"
  value       = aws_rds_cluster.postgresql.endpoint
}

output "jdbc_url" {
  description = "The jdbc url of the postgres instance"
  value       = "jdbc:postgresql://${aws_rds_cluster.postgresql.endpoint}/${aws_rds_cluster.postgresql.database_name}"
}
