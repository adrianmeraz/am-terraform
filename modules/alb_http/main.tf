resource "aws_lb" "main" {
  name               = "${var.name_prefix}-lb"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.private_subnet_ids
  security_groups    = var.security_group_ids

  tags               = var.tags
}

resource "aws_lb_target_group" "main" {
  name = "${var.name_prefix}-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  tags = var.tags
}

# Create the ALB listener with the target group.
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = var.tags
}