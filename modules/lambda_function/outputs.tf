output "arn" {
  description = "arn of the lambda function"
  value       = aws_lambda_function.this.arn
}
