output "log_group" {
  description = "Full ARN of the repository"
  value       = aws_cloudwatch_log_group.main
}
