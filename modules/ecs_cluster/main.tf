locals {
  task_secrets = [for k, v in var.task.secrets : {name: k, valueFrom: v}]
}

resource "aws_ecs_cluster" "main" {
  name = var.name
  tags = var.tags
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name}_task"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.service.launch_type]
  memory                   = var.task.memory_mb
  cpu                      = var.task.vcpu
  execution_role_arn       = var.execution_role_arn
  container_definitions    = <<EOF
[
  {
    "name": "${var.name}",
    "image": "${var.image}",
    "memory": ${var.task.memory_mb},
    "cpu": ${var.task.vcpu},
    "essential": true,
    "entryPoint": ["/"],
    "secrets": ${jsonencode(local.task_secrets)},
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
    subnets = var.service.network_configuration.subnets
  }

  tags = var.tags
}

