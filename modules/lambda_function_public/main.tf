locals {
  clean_lambda_module_name =  replace(var.lambda_module_name, "_", "-")
}

resource "aws_lambda_function" "main" {
  function_name    = "${var.app_name}-${local.clean_lambda_module_name}-${var.environment}"
  image_uri        = var.image_uri
  memory_size      = var.memory_size
  package_type     = var.package_type
  role             = var.role_arn
  source_code_hash = var.source_code_hash
  timeout          = var.timeout_seconds
  image_config {
    command = [var.image_config_command]
  }
  environment {
    variables = var.lambda_environment
  }

  tags = var.tags
}

module "lambda_logs" {
  source            = "../../modules/logs"
  depends_on = [
    aws_lambda_function.main
  ]

  aws_service_name  = "lambda"
  group_name = aws_lambda_function.main.function_name
  retention_in_days = 14

  tags              = var.tags
}