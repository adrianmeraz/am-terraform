resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = var.cloudwatch_role_arn
}

resource "aws_api_gateway_rest_api" "http" {
  name = "${var.name_prefix}-apigw"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = var.tags

}

//Add in later
resource "aws_api_gateway_authorizer" "cognito" {
  name          = "${var.name_prefix}-au  thorizer"
  rest_api_id   = aws_api_gateway_rest_api.http.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_pool_arn]
}

module "apigw_integration" {
  source = "../apigw_lambda_integration"

  for_each                   = {for cfg in var.lambda_configs: cfg.function_name => cfg}

  cognito_authorizer_id      = aws_api_gateway_authorizer.cognito.id
  http_method                = each.value.http_method
  name_prefix                = var.name_prefix
  lambda_function_invoke_arn = each.value.invoke_arn
  lambda_function_name       = each.value.function_name
  path_part                  = each.value.path_part
  rest_api_execution_arn     = aws_api_gateway_rest_api.http.execution_arn
  rest_api_id                = aws_api_gateway_rest_api.http.id
  root_resource_id           = aws_api_gateway_rest_api.http.root_resource_id
}

resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    module.apigw_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.http.id
  stage_name  = var.environment
}

# Set a default stage
resource "aws_api_gateway_stage" "default" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.http.id
  stage_name    = var.environment
  access_log_settings {
    destination_arn = var.cloudwatch_log_group_arn
    # Format taken from here: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
    format          = jsonencode(
      {
        requestId         = "$context.requestId"
        extendedRequestId = "$context.extendedRequestId"
        caller            = "$context.identity.caller"
        httpMethod        = "$context.httpMethod"
        ip                = "$context.identity.sourceIp"
        protocol          = "$context.protocol"
        requestTime       = "$context.requestTime"
        resourcePath      = "$context.resourcePath"
        responseLength    = "$context.responseLength"
        status            = "$context.status"
        user              = "$context.identity.user"
      }
    )
  }

  tags = var.tags
}

resource "aws_api_gateway_method_settings" "main" {
  rest_api_id = aws_api_gateway_rest_api.http.id
  stage_name  = aws_api_gateway_stage.default.stage_name
  method_path = "*/*"
  settings {
    logging_level = "INFO"
    data_trace_enabled = true
    metrics_enabled = true
  }
}