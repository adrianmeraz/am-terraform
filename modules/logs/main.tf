resource "aws_cloudwatch_log_group" "main" {
  name              = "/${var.app_name}/${var.environment}/${var.service_name}"
  retention_in_days = var.retention_in_days

  tags = var.tags
}
