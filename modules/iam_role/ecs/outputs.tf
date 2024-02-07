output "arn" {
  description = "arn of the role"
  value       = aws_iam_role.ecs.arn
}

output "role_name" {
  description = "Role Name"
  value       = aws_iam_role.ecs.name
}