output "arn" {
  description = "arn of the lambda role"
  value       = aws_iam_role.lambda_role.arn
}

output "name" {
  description = "Role Name"
  value       = aws_iam_role.lambda_role.name
}