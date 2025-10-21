locals {
  lambda_cmd_prefix      = "src"
  lambda_handler_name    = "handler"
  lambda_timeout_seconds = 15
  lambda_configs = [
    {
      http_method     = "ANY"
      module_name     = "main"
      path_part       = "{proxy+}"
      is_authorized    = false
      timeout_seconds = local.lambda_timeout_seconds
    },
  ]
}

module "app_python_serverless" {
  source = "../../../../_templates/app_python_serverless"

  app_name                       = var.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  dynamo_db_config               = {
    hash_key_name   = "pk",
    range_key_name  = "sk",
    ttl_attr_name   = "expires_at"
  }
  environment                    = var.environment
  lambda_cmd_prefix              = local.lambda_cmd_prefix
  lambda_configs                 = local.lambda_configs
  lambda_handler_name            = local.lambda_handler_name
  lambda_memory_MB               = var.lambda_memory_MB
  secret_map                     = var.secret_map
  shared_app_name                = var.shared_app_name
}
