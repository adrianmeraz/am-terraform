resource "aws_api_gateway_rest_api" "http" {
  name = "${var.name_prefix}-apigw"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = var.tags
}


module "apigw_integration" {
  source = "../apigw_lambda_integration"

  for_each                   = {for cfg in var.lambda_configs: cfg.function_name => cfg}

  http_method                = each.value.http_method
  name_prefix                = var.name_prefix
  lambda_function_invoke_arn = each.value.invoke_arn
  lambda_function_name       = each.value.function_name
  path_part                  = each.value.path_part
  rest_api_execution_arn     = aws_api_gateway_rest_api.http.execution_arn
  rest_api_id                = aws_api_gateway_rest_api.http.id
  root_resource_id           = aws_api_gateway_rest_api.http.root_resource_id
}

//Add in later
#resource "aws_api_gateway_authorizer" "main" {
#  name          = "${var.name_prefix}-authorizer"
#  rest_api_id   = local.api_id
#  type          = "COGNITO_USER_POOLS"
#  provider_arns = [aws_cognito_user_pool.pool.arn]
#}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.http.id
  stage_name  = var.environment

  depends_on = [
    module.apigw_integration
  ]
}

# Set a default stage
#resource "aws_api_gateway_stage" "default" {
#  deployment_id = aws_api_gateway_deployment.main.id
#  rest_api_id   = aws_api_gateway_rest_api.http.id
#  stage_name    = var.environment
#  access_log_settings {
#    destination_arn = var.cloudwatch_log_group_arn
#    # Format taken from here: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
#    format          = jsonencode(
#      {
#        requestId         = "$context.requestId"
#        extendedRequestId = "$context.extendedRequestId"
#        caller            = "$context.identity.caller"
#        httpMethod        = "$context.httpMethod"
#        ip                = "$context.identity.sourceIp"
#        protocol          = "$context.protocol"
#        requestTime       = "$context.requestTime"
#        resourcePath      = "$context.resourcePath"
#        responseLength    = "$context.responseLength"
#        status            = "$context.status"
#        user              = "$context.identity.user"
#      }
#    )
#  }
#
#  tags = var.tags
#}
