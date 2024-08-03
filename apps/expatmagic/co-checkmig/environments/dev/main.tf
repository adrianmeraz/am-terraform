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
  cognito_pool_arn = tolist(data.aws_cognito_user_pools.shared.arns)[0]
  cognito_pool_id = tolist(data.aws_cognito_user_pools.shared.ids)[0]
  lambda_cmd_prefix = "src.lambdas"
  lambda_handler_name = "lambda_handler"
  lambda_environment = merge(local.secret_map, var.lambda_environment)
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
  lambda_memory_MB               = var.lambda_memory_MB
  lambda_configs = [
    {
      base_function_name   = "bio-get-details"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_bio_get_details.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "bio-get-document-types-by-nationality"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_bio_get_document_types_by_nationality.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "bio-get-travel-reasons-by-nationality"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_bio_get_travel_reasons_by_nationality.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-control-points"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_travel_get_control_points.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-countries"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_travel_get_countries.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-details"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_travel_get_details.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-origin-cities"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_travel_get_origin_cities.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-get-routes"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.api_travel_get_routes.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    },
    {
      base_function_name   = "travel-post-details"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.api_travel_post_details.${local.lambda_handler_name}"
      is_protected         = false
      lambda_environment   = local.lambda_environment
      timeout_seconds      = 10
    }
  ]
}