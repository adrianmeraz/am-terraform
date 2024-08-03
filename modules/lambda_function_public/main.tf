resource "aws_lambda_function" "main" {
  function_name    = "${var.app_name}-${var.base_function_name}-${var.environment}"
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
    variables = merge(
      var.lambda_environment,
      {
        "AWS_SECRET_NAME": var.env_aws_secret_name
      }
    )
  }

  tags = var.tags
}