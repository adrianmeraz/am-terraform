output "id" {
  description = "id of the SSM parameter"
  value       = aws_ssm_parameter.secret.id
}

output "name" {
  description = "name of the SSM parameter"
  value       = aws_ssm_parameter.secret.name
}

output "arn" {
  description = "arn of the SSM parameter"
  value       = aws_ssm_parameter.secret.arn
}

output "aws_ssm_parameter" {
  description = "SSM Parameter"
  value       = aws_ssm_parameter.secret
}

output "secret_map" {
  description = "Map of secrets"
  value       = jsondecode(local.secret_string)
}
