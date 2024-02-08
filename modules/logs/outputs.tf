output "log_group" {
  description = "CloudWatch log group"
  value       = aws_cloudwatch_log_group.main
}
