locals {
  lambda_cmd_prefix      = "src.lambdas"
  lambda_handler_name    = "lambda_handler"
  lambda_timeout_seconds = 15
  lambda_configs = [
    {
      http_method     = "ANY"
      module_name     = "event_handler"
      path_part       = "{proxy+}"
      is_authorized   = false
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
  environment                    = var.environment
  lambda_cmd_prefix              = local.lambda_cmd_prefix
  lambda_configs                 = local.lambda_configs
  lambda_handler_name            = local.lambda_handler_name
  lambda_memory_MB               = var.lambda_memory_MB
  secret_map                     = var.secret_map
  shared_app_name                = var.shared_app_name
}