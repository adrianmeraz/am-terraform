output "lambda_env_var_map" {
  description = "lambda environment variables"
  value       = var.lambda_env_var_map
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

output "is_authorized" {
  description = "is lambda endpoint protected by apigw authorizer"
  value       = var.is_authorized
}

output "path_part" {
  description = "Last path segment of this API resource"
  value       = var.path_part
}