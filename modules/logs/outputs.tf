output "cloudwatch_log_group_arn" {
  description = "CloudWatch ARN"
  value       = aws_cloudwatch_log_group.main.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group"
  value       = aws_cloudwatch_log_group.main
}
