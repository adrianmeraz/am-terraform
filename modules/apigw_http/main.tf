resource "aws_apigatewayv2_vpc_link" "private" {
  name               = "${var.name_prefix}-api-vpc-link"
  security_group_ids = []
  subnet_ids         = var.private_subnet_ids

  tags = var.tags
}

resource "aws_apigatewayv2_api" "http" {
  name          = "${var.name_prefix}-api"
  protocol_type = "HTTP"

  tags = var.tags
}

locals {
  api_id = aws_apigatewayv2_api.http.id
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
  api_id = local.api_id
  name   = "${var.name_prefix}-stage"
  access_log_settings {
    destination_arn = var.cloudwatch_log_group_arn
    # Format taken from here: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
    format          = "{'requestId':'$context.requestId','extendedRequestId':'$context.extendedRequestId','ip':'$context.identity.sourceIp','caller':'$context.identity.caller','user':'$context.identity.user','requestTime':'$context.requestTime','httpMethod':'$context.httpMethod','resourcePath':'$context.resourcePath','status':'$context.status','protocol':'$context.protocol','responseLength':'$context.responseLength'}"
  }

  tags = var.tags
}
