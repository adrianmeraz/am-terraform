resource "aws_lambda_function" "main" {
  function_name    = "${var.app_name}-${var.base_function_name}-${var.environment}"
  image_uri        = var.image_uri
  package_type     = var.package_type
  role             = var.role_arn
  source_code_hash = var.source_code_hash
  image_config {
    command = [var.image_config_command]
  }

  tags = var.tags
}