resource "aws_apigatewayv2_vpc_link" "private" {
  name               = "${var.name_prefix}_api_vpc_link"
  security_group_ids = []
  subnet_ids         = var.private_subnet_ids

  tags = var.tags
}

resource "aws_apigatewayv2_api" "http" {
  name          = "${var.name_prefix}_api"
  protocol_type = "HTTP"

  tags = var.tags
}

locals {
  api_id = aws_apigatewayv2_api.http.id
}

resource "aws_apigatewayv2_integration" "main" {
  api_id                 = local.api_id
  connection_type        = "VPC_LINK"
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
  api_id = local.api_id
  name   = "${var.name_prefix}_stage"
  auto_deploy = true

  tags = var.tags
}
