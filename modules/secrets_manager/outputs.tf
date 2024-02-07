output "arn" {
  description = "ARN of secrets manager"
  value       = aws_secretsmanager_secret.main.arn
}


output "secret_map" {
  description = "Map of secrets"
  value       = jsondecode(aws_secretsmanager_secret_version.main.secret_string)
}
