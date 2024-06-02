locals {
  cors_integration_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Credentials"  = "'true'",
  }
  cors_method_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Credentials"  = true,
  }
  response_status_codes = [
    200, 401, 403
  ]
}

resource "aws_api_gateway_resource" "main" {
  parent_id   = var.root_resource_id
  path_part   = var.path_part
  rest_api_id = var.rest_api_id
}

resource "aws_api_gateway_method" "proxy" {
  # authorization  = "NONE"
  authorization  = var.is_protected ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id  = var.is_protected ? var.cognito_authorizer_id : ""
  http_method    = var.http_method
  operation_name = "${aws_api_gateway_resource.main.path_part}-${var.http_method}"
  resource_id    = aws_api_gateway_resource.main.id
  rest_api_id    = var.rest_api_id
}

resource "aws_api_gateway_method_response" "proxy_responses" {
  for_each    = {for status_code in local.response_status_codes: status_code => status_code}

  http_method = aws_api_gateway_method.proxy.http_method
  resource_id = aws_api_gateway_resource.main.id
  rest_api_id = var.rest_api_id
  status_code = each.key

  //cors section
  response_parameters = local.cors_method_response_parameters
}

resource "aws_api_gateway_integration" "lambda" {
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST" # Must always be POST for lambda integrations
  resource_id             = aws_api_gateway_resource.main.id
  rest_api_id             = var.rest_api_id
  # Difference between types: https://stackoverflow.com/questions/62164162/what-is-the-difference-between-aws-and-aws-proxy-in-cloudformationapigateway
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}

resource "aws_api_gateway_integration_response" "proxy" {
  # Note - CORS response headers will NOT be present in response if using proxy type integration.
  # CORS response headers must be set in lambda response
  # See below for further details:
  # https://stackoverflow.com/a/54089431
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html#apigateway-enable-cors-proxy
  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda
  ]
  for_each    = {for status_code in local.response_status_codes: status_code => status_code}

  http_method = aws_api_gateway_method.proxy.http_method
  resource_id = aws_api_gateway_resource.main.id
  rest_api_id = var.rest_api_id
  # status_code = aws_api_gateway_method_response.proxy_200.status_code
  status_code = each.key

  //cors
  response_parameters = local.cors_integration_response_parameters
}

##############################################
##### Options
##############################################

resource "aws_api_gateway_method" "options" {
  # OPTIONS methods should be unauthorized
  # For more info, see: https://stackoverflow.com/a/73342943
#   authorization  = var.is_protected ? "COGNITO_USER_POOLS" : "NONE"
#   authorizer_id  = var.is_protected ? var.cognito_authorizer_id : ""
  authorization  = "NONE"
  http_method    = "OPTIONS"
  operation_name = "${aws_api_gateway_resource.main.path_part}-${var.http_method}"
  resource_id    = aws_api_gateway_resource.main.id
  rest_api_id    = var.rest_api_id
}

resource "aws_api_gateway_method_response" "options_responses" {
  for_each    = {for status_code in local.response_status_codes: status_code => status_code}

  http_method = aws_api_gateway_method.options.http_method
  resource_id = aws_api_gateway_resource.main.id
  rest_api_id = var.rest_api_id
  status_code = each.key

  response_parameters = local.cors_method_response_parameters
}

resource "aws_api_gateway_integration" "options_integrations" {
  for_each                = {for status_code in local.response_status_codes: status_code => status_code}
  http_method             = aws_api_gateway_method.options.http_method
  # Removed to avoid redeploy on every apply per https://github.com/hashicorp/terraform-provider-aws/issues/11810
  # integration_http_method = "OPTIONS"

  resource_id             = aws_api_gateway_resource.main.id
  rest_api_id             = var.rest_api_id
  type                    = "MOCK"
#   request_templates = {
#     "application/json" = "{\"statusCode\": 200}"
#   }
  request_templates = {
    "application/json" = "{\"statusCode\": ${each.key}}"
  }
}

resource "aws_api_gateway_integration_response" "options" {
  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integrations,
  ]
  for_each    = {for status_code in local.response_status_codes: status_code => status_code}

  http_method = aws_api_gateway_method.options.http_method
  resource_id = aws_api_gateway_resource.main.id
  rest_api_id = var.rest_api_id
  # status_code = aws_api_gateway_method_response.options_200.status_code
  status_code = each.key

  response_parameters = local.cors_integration_response_parameters
}

resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"

  source_arn    = "${var.rest_api_execution_arn}/*/*/*"
}
