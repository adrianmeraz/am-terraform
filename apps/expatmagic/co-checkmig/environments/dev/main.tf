data "aws_secretsmanager_secret_version" "shared" {
  secret_id = var.shared_secret_id
}

locals  {
  app_name           = "co-checkmig"
  environment        = "dev"
  lambda_timeout     = 5
  name_prefix        = "${local.app_name}-${local.environment}"
  secret_map         = jsondecode(data.aws_secretsmanager_secret_version.shared.secret_string)
}

data "aws_cognito_user_pools" "shared" {
  name = local.secret_map["COGNITO_POOL_NAME"]
}

locals {
  cognito_pool_arn = tolist(data.aws_cognito_user_pools.shared.arns)[0]
  cognito_pool_id = tolist(data.aws_cognito_user_pools.shared.ids)[0]
  lambda_cmd_prefix = "src.lambdas"
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

  app_name                       = local.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  cognito_pool_arn               = local.cognito_pool_arn
  cognito_pool_client_id         = local.cognito_pool_client_id
  cognito_pool_id                = local.cognito_pool_id
  dynamo_db_table_name           = module.dynamo_db.table_name
  environment                    = local.environment
  force_overwrite_secrets        = var.force_overwrite_secrets
  lambda_configs = [
    {
      base_function_name   = "get-bio-details"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_get_bio_details.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-travel-control-points"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_get_travel_control_points.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-travel-countries"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_get_travel_countries.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-travel-origin-cities"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_get_travel_origin_cities.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-travel-routes"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_get_travel_routes.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-travel-tokens"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_get_travel_tokens.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "post-travel-details"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.api_post_travel_details.lambda_handler"
      is_protected         = false
      lambda_environment   = var.lambda_environment
      timeout_seconds      = 10
    }
  ]
}