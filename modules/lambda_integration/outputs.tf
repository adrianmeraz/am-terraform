output "aws_api_gateway_resource_id" {
  description = "AWS API Gateway Resource Id"
  value       = aws_api_gateway_resource.main.id
}

output "aws_api_gateway_method_proxy_id" {
  description = "AWS API Gateway Method Proxy Id"
  value       = aws_api_gateway_method.proxy.id
}

output "aws_api_gateway_method_options_id" {
  description = "AWS API Gateway Method Options Id"
  value       = aws_api_gateway_method.options.id
}
