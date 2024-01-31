resource "aws_ecs_cluster" "this" {
  name = var.name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}_task"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.service.launch_type]
  memory                   = var.task.memory
  cpu                      = var.task.cpu
  execution_role_arn       = var.execution_role_arn
  container_definitions    = <<EOF
[
  {
    "name": "${var.name}",
    "image": "${var.image}",
    "memory": ${var.task.memory},
    "cpu": ${var.task.cpu},
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}_service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = var.service.launch_type

  desired_count = var.service.desired_count
  network_configuration {
    assign_public_ip = var.service.network_configuration.assign_public_ip
    subnets = var.service.network_configuration.subnets
  }
}

