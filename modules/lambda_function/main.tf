locals {
  cidr_ipv4_all    = "0.0.0.0/0"
  cidr_ipv6_all    = "::/0"
}

resource "aws_security_group" "lambda" {
  name        = "${var.function_name}-lambda-sg"
  description = "Allow incoming postgres traffic"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_http_ipv4" {
  cidr_ipv4         = local.cidr_ipv4_all
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.lambda.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_http_ipv6" {
  cidr_ipv6         = local.cidr_ipv6_all
  description       = var.function_name
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.lambda.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_tls_ipv4" {
  cidr_ipv4         = local.cidr_ipv4_all
  description       = var.function_name
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.lambda.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_tls_ipv6" {
  cidr_ipv6         = local.cidr_ipv6_all
  description       = var.function_name
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.lambda.id

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv4" {
  cidr_ipv4         = local.cidr_ipv4_all
  description       = var.function_name
  ip_protocol       = "-1" # semantically equivalent to all ports
  security_group_id = aws_security_group.lambda.id

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv6" {
  cidr_ipv6         = local.cidr_ipv6_all
  description       = var.function_name
  ip_protocol       = "-1" # semantically equivalent to all ports
  security_group_id = aws_security_group.lambda.id

  tags = var.tags
}

resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  handler          = var.handler
  image_uri        = var.image_uri
  package_type     = var.package_type
  role             = var.role
  runtime          = var.runtime
  source_code_hash = var.source_code_hash
  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids         = var.subnet_ids
  }

  tags = var.tags
}