resource "aws_api_gateway_rest_api" "http" {
  name          = "${var.name_prefix}-api"
  protocol_type = "HTTP"

  tags = var.tags
}

locals {
  api_id = aws_api_gateway_rest_api.http.id
}

//Add in later
#resource "aws_api_gateway_authorizer" "main" {
#  name          = "${var.name_prefix}-authorizer"
#  rest_api_id   = local.api_id
#  type          = "COGNITO_USER_POOLS"
#  provider_arns = [aws_cognito_user_pool.pool.arn]
#}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = local.api_id
  parent_id = aws_api_gateway_rest_api.http.root_resource_id
  path_part = var.environment
}

# Set a default stage
resource "aws_apigatewayv2_stage" "default" {
  auto_deploy = true
  api_id      = local.api_id
  name        = "$default"
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
