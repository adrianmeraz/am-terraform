locals {
  cidr_ipv4_all    = "0.0.0.0/0"
  cidr_ipv6_all    = "::/0"
}

##############################################
##### Security group
##############################################
resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "Allow http/https and tomcat inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_tomcat" {
  cidr_ipv4         = local.cidr_ipv4_all
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_http_ipv4" {
  cidr_ipv4         = local.cidr_ipv4_all
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_http_ipv6" {
  cidr_ipv6         = local.cidr_ipv6_all
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_tls_ipv4" {
  cidr_ipv4         = local.cidr_ipv4_all
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_incoming_tls_ipv6" {
  cidr_ipv6         = local.cidr_ipv6_all
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv4" {
  cidr_ipv4         = local.cidr_ipv4_all
  ip_protocol       = "-1" # semantically equivalent to all ports
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_traffic_ipv6" {
  cidr_ipv6         = local.cidr_ipv6_all
  ip_protocol       = "-1" # semantically equivalent to all ports
  security_group_id = aws_security_group.ecs.id

  tags = var.tags
}

##############################################
##### ECS Cluster Config
##############################################

resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-ecs-cluster"
  tags = var.tags
}

resource "aws_ecs_service" "main" {
  name                 = "${var.name_prefix}-ecs-service"
  cluster              = aws_ecs_cluster.main.id
  desired_count        = var.desired_count
  force_new_deployment = true
  launch_type          = var.launch_type
  propagate_tags       = "TASK_DEFINITION"
  task_definition      = var.task_definition_arn
  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.container_name
    container_port   = 8080
  }
  network_configuration {
    assign_public_ip = var.network_configuration.assign_public_ip
    security_groups  = [aws_security_group.ecs.id]
    subnets          = var.network_configuration.subnets
  }
  triggers = {
    redeployment = plantimestamp()  # force update in-place every apply
  }

  tags = var.tags
}
