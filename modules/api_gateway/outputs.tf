output "api_gateway_rest_api_id" {
  description = "ID of the API Gateway"
  value = aws_api_gateway_rest_api.http.id
}

output "api_gateway_stage_name" {
  description = "Stage name of the API Gateway"
  value = aws_api_gateway_stage.default.stage_name
}

