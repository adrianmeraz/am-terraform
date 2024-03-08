output "function_name" {
  description = "lambda function name"
  value       = aws_lambda_function.main.function_name
}

output "invoke_arn" {
  description = "arn of the lambda function"
  value       = aws_lambda_function.main.invoke_arn
}

output "http_method" {
  description = "http method derived from function name"
  value       = var.http_method
}
