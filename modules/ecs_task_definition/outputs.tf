output "arn" {
  description = "Full ARN of the task definition"
  value       = aws_ecs_task_definition.main.arn
}
