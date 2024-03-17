output "secretsmanager_secret_id" {
  description = "id of the secrets manager"
  value       = aws_secretsmanager_secret.main.id
}

output "secretsmanager_secret_name" {
  description = "name of the secrets manager"
  value       = aws_secretsmanager_secret.main.name
}

output "arn" {
  description = "arn of the secrets manager"
  value       = aws_secretsmanager_secret.main.arn
}

output "secretsmanager" {
  description = "secrets manager"
  value       = aws_secretsmanager_secret.main
}

output "secret_map" {
  description = "Map of secrets"
  value       = jsondecode(local.secret_string)
}
