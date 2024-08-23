locals  {
  name_prefix        = "${var.app_name}-${var.environment}"
}

locals {
  lambda_cmd_prefix   = "src.lambdas"
  lambda_handler_name = "lambda_handler"
  lambda_configs = [
    {
      http_method     = "GET"
      module_name     = "api_get_pingback_verification_token"
      path_part       = "2captcha.txt"
      is_protected    = false
      timeout_seconds = 10
    },
    {
      http_method     = "POST"
      module_name     = "api_post_add_pingback"
      path_part       = "pingback"
      is_protected    = false
      timeout_seconds = 10
    },
    {
      http_method     = "POST"
      module_name     = "api_post_pingback_event"
      path_part       = "pingback-event"
      is_protected    = false
      timeout_seconds = 10
    },
    {
      http_method     = "POST"
      module_name     = "api_post_report_bad_captcha"
      path_part       = "report-bad-captcha"
      is_protected    = false
      timeout_seconds = 10
    },
    {
      http_method     = "POST"
      module_name     = "api_post_report_good_captcha"
      path_part       = "report-good-captcha"
      is_protected    = false
      timeout_seconds = 10
    },
    {
      http_method     = "POST"
      module_name     = "api_post_solve_captcha"
      path_part       = "solve-captcha"
      is_protected    = false
      timeout_seconds = 10
    }
  ]
}

module "dynamo_db" {
  source = "../../../../modules/dynamo_db"

  name_prefix = local.name_prefix
}


module "app_python_serverless" {
  source = "../../../../_templates/app_python_serverless"

  app_name                       = var.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  dynamo_db_table_name           = module.dynamo_db.table_name
  environment                    = var.environment
  lambda_cmd_prefix              = local.lambda_cmd_prefix
  lambda_configs                 = local.lambda_configs
  lambda_handler_name            = local.lambda_handler_name
  lambda_memory_MB               = var.lambda_memory_MB
  shared_app_name                = var.shared_app_name
}
