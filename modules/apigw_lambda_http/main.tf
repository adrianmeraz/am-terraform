resource "aws_api_gateway_rest_api" "http" {
  name          = "${var.name_prefix}-api"
  protocol_type = "HTTP"

  tags = var.tags
}

locals {
  api_id = aws_apigatewayv2_api.http.id
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = local.api_id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "mypath"
}

resource "aws_apigatewayv2_integration" "main" {
  api_id                 = local.api_id
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.private.id
  integration_method     = "ANY"
  integration_type       = "HTTP_PROXY"
  integration_uri        = var.aws_lb_listener_arn
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "any" {
  api_id     = local.api_id
  # route_key  = "ANY /${var.environment}/{proxy+}"
  route_key  = "ANY /{proxy+}"
  target     = "integrations/${aws_apigatewayv2_integration.main.id}"
  depends_on = [aws_apigatewayv2_integration.main]
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
