resource "aws_api_gateway_rest_api" "http" {
  name          = "${var.name_prefix}-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = var.tags
}

locals {
  rest_api_id = aws_api_gateway_rest_api.http.id
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = local.rest_api_id
  parent_id   = aws_api_gateway_rest_api.http.root_resource_id
  path_part   = var.environment
}

module "apigw_integration" {
  source = "../apigw_integration"

  http_method        = "POST"
  name_prefix        = var.name_prefix
  parent_rest_api_id = local.rest_api_id
  path_part          = "traveler"
  resource_id        = aws_api_gateway_resource.root.id
  rest_api_id        = local.rest_api_id
}

//Add in later
#resource "aws_api_gateway_authorizer" "main" {
#  name          = "${var.name_prefix}-authorizer"
#  rest_api_id   = local.api_id
#  type          = "COGNITO_USER_POOLS"
#  provider_arns = [aws_cognito_user_pool.pool.arn]
#}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = local.rest_api_id

  lifecycle {
    create_before_destroy = true
  }
}

# Set a default stage
resource "aws_api_gateway_stage" "default" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id = local.rest_api_id
  stage_name = var.environment
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

  tags = var.tags
}
