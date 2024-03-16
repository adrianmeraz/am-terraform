locals {
  app_name    = "emcore"
  environment = "dev"
  name_prefix = "${local.app_name}-${local.environment}"
}

data "aws_secretsmanager_secret_version" "shared" {
  secret_id = var.shared_secret_id
}

locals  {
  secret_map = jsondecode(data.aws_secretsmanager_secret_version.shared.secret_string)
}

data "aws_cognito_user_pools" "shared" {
  name = local.secret_map["COGNITO_POOL_NAME"]
}

module "dynamo_db" {
  source = "../../modules/dynamo_db"

  name_prefix = local.name_prefix
  replica_region_name = var.aws_region
}

module "app_python_lambda" {
  source = "../../../../_templates/app_python_serverless"

  app_name                       = local.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  cognito_pool_arn               = tolist(data.aws_cognito_user_pools.shared.arns)[0]
  dynamo_db_table_name           = module.dynamo_db.table_name
  environment                    = local.environment
  lambda_configs = [
    {
      base_function_name   = "add-organization"
      http_method          = "POST"
      image_config_command = "add_organization_api.lambda_handler"
    },
    {
      base_function_name   = "get-organization"
      http_method          = "GET"
      image_config_command = "get_organization_api.lambda_handler"
    },
    {
      base_function_name   = "add-traveler"
      http_method          = "POST"
      image_config_command = "add_traveler_api.lambda_handler"
    },
    {
      base_function_name   = "add-user"
      http_method          = "POST"
      image_config_command = "add_user_api.lambda_handler"
    },
    {
      base_function_name   = "delete-traveler"
      http_method          = "DELETE"
      image_config_command = "delete_traveler_api.lambda_handler"
    }
  ]
}