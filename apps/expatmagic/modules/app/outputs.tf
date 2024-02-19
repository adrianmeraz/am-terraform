output "role_arn" {
  description = "role arn"
  value       = aws_iam_role.ecs.arn
}

output "role_name" {
  description = "Role Name"
  value       = aws_iam_role.ecs.name
}