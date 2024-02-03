output "secret_map" {
  description = "Map of secrets"
  value       = jsondecode(data.aws_secretsmanager_secret_version.main.secret_string)
}
