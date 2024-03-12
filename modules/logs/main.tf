resource "aws_cloudwatch_log_group" "main" {
  name              = "aws/${var.aws_service_name}/${var.app_name}/${var.environment}/"
  retention_in_days = var.retention_in_days

  tags = var.tags
}
