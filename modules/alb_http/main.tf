resource "aws_lb" "main" {
  name               = "${var.name_prefix}-lb"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.private_subnet_ids
  security_groups    = var.security_group_ids

  tags               = var.tags
}

resource "aws_lb_target_group" "app" {
  name = "${var.name_prefix}-lb-tg"
  port        = var.app_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    enabled = true
    path = var.health_check_path
    port = var.app_container_port
  }

  tags = var.tags
}

# Create the ALB HTTP listener with the target group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = var.tags
}

# Create the ALB HTTPS listener with the target group.
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = var.tags
}