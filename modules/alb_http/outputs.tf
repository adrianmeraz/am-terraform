output "aws_lb_http_listener_arn" {
  value = aws_lb_listener.http.arn
  description = "LB HTTP Listener ARN"
}

output "aws_lb_https_listener_arn" {
  value = aws_lb_listener.http.arn
  description = "LB HTTPS Listener ARN"
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.main.arn
  description = "LB Target Group ARN"
}
