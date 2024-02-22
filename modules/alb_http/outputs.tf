output "aws_lb_listener_arn" {
  value = aws_lb_listener.main.arn
  description = "ECS Listener ARN"
}
