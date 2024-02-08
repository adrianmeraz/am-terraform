locals {
  cidr_ipv4    = "0.0.0.0/0"
  cidr_ipv6    = "::/0"
}

resource "aws_ecs_cluster" "main" {
  name = var.name
  tags = var.tags
}

resource "aws_ecs_service" "main" {
  name            = "${var.name}_service"
  cluster         = aws_ecs_cluster.main.id
  desired_count = var.desired_count
  launch_type     = var.launch_type
  network_configuration {
    assign_public_ip = var.network_configuration.assign_public_ip
    security_groups = [aws_security_group.main.id]
    subnets = var.network_configuration.subnets
  }
  task_definition = var.task_definition_arn

  tags = var.tags
}

#######################
##### Security group
#######################
resource "aws_security_group" "main" {
  name        = "ecs_allow_http"
  description = "Allow secure and insecure http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  cidr_ipv4         = local.cidr_ipv4
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  cidr_ipv6         = local.cidr_ipv6
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  cidr_ipv4         = local.cidr_ipv4
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  cidr_ipv6         = local.cidr_ipv6
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  cidr_ipv4         = local.cidr_ipv4
  ip_protocol       = "-1" # semantically equivalent to all ports
  security_group_id = aws_security_group.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  cidr_ipv6         = local.cidr_ipv6
  ip_protocol       = "-1" # semantically equivalent to all ports
  security_group_id = aws_security_group.main.id

  tags = var.tags
}
