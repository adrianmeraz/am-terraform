resource "aws_api_gateway_resource" "main" {
  parent_id   = var.root_resource_id
  path_part   = var.path_part
  rest_api_id = var.rest_api_id
}

resource "aws_api_gateway_method" "proxy" {
  authorization  = "NONE"
  #  authorization = "COGNITO_USER_POOLS"
  #  authorizer_id = var.authorizer_id
  http_method    = var.http_method
  operation_name = "${aws_api_gateway_resource.main.path_part}-${var.http_method}"
  rest_api_id    = var.rest_api_id
  resource_id    = aws_api_gateway_resource.main.id
}

resource "aws_api_gateway_method_response" "proxy" {
  http_method = aws_api_gateway_method.proxy.http_method
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.main.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = aws_api_gateway_method.proxy.http_method
  type                    = "AWS"
  uri                     = var.lambda_function_invoke_arn
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy.status_code

  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda
  ]
}

##############################################
##### Options
##############################################

resource "aws_api_gateway_method" "options" {
  http_method    = "OPTIONS"
  operation_name = "${aws_api_gateway_resource.main.path_part}-${var.http_method}"
  rest_api_id    = var.rest_api_id
  resource_id    = aws_api_gateway_resource.main.id
  authorization  = "NONE"
#  authorization = "COGNITO_USER_POOLS"
#  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.main.id
  http_method             = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options,
  ]
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${var.rest_api_execution_arn}/*/*/*"
}