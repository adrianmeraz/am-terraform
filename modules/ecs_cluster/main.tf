resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}_${var.environment}"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.app_name}_${var.environment}_task"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.service.launch_type]
  memory                   = var.task.memory
  cpu                      = var.task.cpu
  execution_role_arn       = var.execution_role_arn
  container_definitions    = <<EOF
[
  {
    "name": "${var.app_name}_${var.environment}",
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
  name            = "${var.app_name}_${var.environment}_service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = var.service.launch_type

  desired_count = var.service.desired_count
}

