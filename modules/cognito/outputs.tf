output "pool_arn" {
  description = "Cognito Pool ARN"
  value       = aws_cognito_user_pool.main.arn
}

output "pool_id" {
  description = "Cognito Pool ID"
  value       = aws_cognito_user_pool.main.id
}

output "pool_name" {
  description = "Cognito Pool name"
  value       = aws_cognito_user_pool.main.name
}