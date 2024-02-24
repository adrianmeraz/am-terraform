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
    interval            = var.alb_tg_health_check.interval
    enabled             = var.alb_tg_health_check.enabled
    path                = var.alb_tg_health_check.path
    port                = var.alb_tg_health_check.port
    protocol            = var.alb_tg_health_check.protocol
    healthy_threshold   = var.alb_tg_health_check.healthy_threshold
    unhealthy_threshold = var.alb_tg_health_check.unhealthy_threshold
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