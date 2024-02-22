output "aws_lb_listener_arn" {
  value = aws_lb_listener.main.arn
  description = "LB Listener ARN"
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.main.arn
  description = "LB Target Group ARN"
}
