resource "aws_ecs_task_definition" "main" {
  cpu                      = var.vcpu
  execution_role_arn       = var.execution_role_arn
  family                   = "${var.name_prefix}-task"
  memory                   = var.memory_mb
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  container_definitions    = var.container_definitions
  tags                     = var.tags
}
