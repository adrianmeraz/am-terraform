locals {
  cidr_ipv4    = "0.0.0.0/0"
  cidr_ipv6    = "::/0"
}

resource "aws_ecs_cluster" "main" {
  name = var.name
  tags = var.tags
}

resource "aws_ecs_task_definition" "main" {
  cpu                      = var.task.vcpu
  execution_role_arn       = var.execution_role_arn
  family                   = "${var.name}_task"
  memory                   = var.task.memory_mb
  network_mode             = "awsvpc"
  requires_compatibilities = [var.service.launch_type]
  container_definitions    = <<EOF
[
  {
    "name": "${var.name}",
    "image": "${var.image}",
    "memory": ${var.task.memory_mb},
    "cpu": ${var.task.vcpu},
    "essential": true,
    "secrets": [
      {
        "valueFrom": "${var.task.secrets.secretsmanager_arn}",
        "name": "${var.task.secrets.secretsmanager_name}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ]
  }
]
EOF
  tags = var.tags
}

resource "aws_ecs_service" "main" {
  name            = "${var.name}_service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type     = var.service.launch_type

  desired_count = var.service.desired_count
  network_configuration {
    assign_public_ip = var.service.network_configuration.assign_public_ip
    subnets = var.service.network_configuration.subnet_ids
    security_groups = [aws_security_group.main.id]
  }

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
