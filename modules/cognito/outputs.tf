output "pool_arn" {
  description = "Cognito Pool ARN"
  value       = aws_cognito_user_pool.main.arn
}

output "client_id" {
  description = "Cognito Client ID"
  value       = aws_cognito_user_pool_client.main.id
}