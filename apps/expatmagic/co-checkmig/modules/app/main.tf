data "aws_secretsmanager_secret_version" "shared" {
  secret_id = var.shared_secret_id
}

locals  {
  name_prefix        = "${var.app_name}-${var.environment}"
  secret_map         = jsondecode(data.aws_secretsmanager_secret_version.shared.secret_string)
}

data "aws_cognito_user_pools" "shared" {
  name = local.secret_map["COGNITO_POOL_NAME"]
}

locals {
  cognito_pool_arn    = tolist(data.aws_cognito_user_pools.shared.arns)[0]
  cognito_pool_id     = tolist(data.aws_cognito_user_pools.shared.ids)[0]
  lambda_cmd_prefix   = "src.lambdas"
  lambda_handler_name = "lambda_handler"
  lambda_environment  = merge(local.secret_map, var.lambda_environment)
  lambda_configs = [
    {
      base_function_name   = "bio-get-details"
      http_method          = "GET"
      module_name          = "api_bio_get_details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "bio-get-document-types-by-nationality"
      http_method          = "GET"
      module_name          = "api_bio_get_document_types_by_nationality"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "bio-get-is-visa-required"
      http_method          = "GET"
      module_name          = "api_bio_get_is_visa_required"
      is_protected         = false
      timeout_seconds      = 10
    },
#     {
#       base_function_name   = "bio-get-special-visa-types"
#       http_method          = "GET"
#       module_name          = "api_bio_get_special_visa_types"
#       is_protected         = false
#       timeout_seconds      = 10
#     },
    {
      base_function_name   = "bio-get-travel-reasons-by-nationality"
      http_method          = "GET"
      module_name          = "api_bio_get_travel_reasons_by_nationality"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-control-points"
      http_method          = "GET"
      module_name          = "api_travel_get_control_points"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-countries"
      http_method          = "GET"
      module_name          = "api_travel_get_countries"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-details"
      http_method          = "GET"
      module_name          = "api_travel_get_details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-origin-cities"
      http_method          = "GET"
      module_name          = "api_travel_get_origin_cities"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-routes"
      http_method          = "GET"
      module_name          = "api_travel_get_routes"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-post-details"
      http_method          = "POST"
      module_name          = "api_travel_post_details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "twocaptcha-get-verification"
      http_method          = "GET"
      module_name          = "api_twocaptcha_get_verification"
      is_protected         = false
      timeout_seconds      = 10
    }
  ]
}

data "aws_cognito_user_pool_clients" "shared" {
  user_pool_id = local.cognito_pool_id
}

locals {
  cognito_pool_client_id = tolist(data.aws_cognito_user_pool_clients.shared.client_ids)[0]
}

module "dynamo_db" {
  source = "../../../../../modules/dynamo_db"

  name_prefix = local.name_prefix
}


module "app_python_serverless" {
  source = "../../../../_templates/app_python_serverless"

  app_name                       = var.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  cognito_pool_arn               = local.cognito_pool_arn
  cognito_pool_client_id         = local.cognito_pool_client_id
  cognito_pool_id                = local.cognito_pool_id
  dynamo_db_table_name           = module.dynamo_db.table_name
  environment                    = var.environment
  force_overwrite_secrets        = var.force_overwrite_secrets
  lambda_cmd_prefix              = local.lambda_cmd_prefix
  lambda_configs                 = local.lambda_configs
  lambda_handler_name            = local.lambda_handler_name
  lambda_memory_MB               = var.lambda_memory_MB
}