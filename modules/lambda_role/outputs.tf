output "arn" {
  description = "arn of the lambda role"
  value       = aws_iam_role.lambda.arn
}

output "name" {
  description = "Role Name"
  value       = aws_iam_role.lambda.name
}