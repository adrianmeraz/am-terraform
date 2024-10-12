output "secret_map" {
  description = "Map of secrets"
  value       = local.shared_secret_map
}

output "base_domain_name" {
  description = "Base Domain Name secret"
  value       = local.shared_secret_map["BASE_DOMAIN_NAME"]
}

output "cognito_pool_arn" {
  description = "ARN of Cognito Pool"
  value       = local.cognito_pool_arn
}

output "cognito_pool_id" {
  description = "ID of Cognito Pool"
  value       = local.cognito_pool_id
}

output "cognito_pool_client_id" {
  description = "Client ID of Cognito Pool"
  value       = local.cognito_pool_client_id
}