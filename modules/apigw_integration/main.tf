resource "aws_api_gateway_method" "proxy" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = "POST"
  authorization = "NONE"
}

locals {
  http_method = aws_api_gateway_method.proxy.http_method
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = local.http_method
  integration_http_method = local.http_method
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = local.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = local.http_method
  status_code = aws_api_gateway_method_response.proxy.status_code

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda_integration
  ]
}