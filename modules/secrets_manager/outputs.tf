output "secret_map" {
  description = "Map of secrets"
  value       = jsondecode(data.aws_secretsmanager_secret_version.d_secrets_version.secret_string)
}
