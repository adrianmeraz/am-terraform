output "secretsmanager" {
  description = "secrets manager"
  value       = aws_secretsmanager_secret.main
}

output "secret_map" {
  description = "Map of secrets"
  value       = jsondecode(aws_secretsmanager_secret_version.main.secret_string)
}

output "task_secrets" {
  description = "Secrets in format for ecs task"
  value       = [for key, value in jsondecode(aws_secretsmanager_secret_version.main.secret_string): {name = key, valueFrom = "${aws_secretsmanager_secret_version.main.arn}:${key}::"}]
}
