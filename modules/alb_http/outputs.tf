output "http_aws_lb_listener_arn" {
  value = aws_lb_listener.http.arn
  description = "HTTP LB Listener ARN"
}

output "https_aws_lb_listener_arn" {
  value = aws_lb_listener.http.arn
  description = "HTTPS LB Listener ARN"
}

output "app_aws_lb_target_group_arn" {
  value = aws_lb_target_group.app.arn
  description = "APP LB Target Group ARN"
}
