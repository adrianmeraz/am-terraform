output "base_function_name" {
  description = "Base unique name for Lambda Function"
  value       = var.base_function_name
}

output "lambda_environment" {
  description = "lambda environment variables"
  value       = var.lambda_environment
}

output "function_name" {
  description = "lambda function name"
  value       = aws_lambda_function.main.function_name
}

output "http_method" {
  description = "http method derived from function name"
  value       = var.http_method
}

output "invoke_arn" {
  description = "arn of the lambda function"
  value       = aws_lambda_function.main.invoke_arn
}

output "is_protected" {
  description = "is lambda endpoint protected by apigw authorizer"
  value       = var.is_protected
}
