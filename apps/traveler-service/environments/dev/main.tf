locals {
  app_name    = "traveler-service"
  environment = "dev"
  name_prefix = "${local.app_name}-${local.environment}"
}

module "dynamo_db" {
  source = "../../modules/dynamo_db"

  name_prefix = local.name_prefix
}

module "app_python_lambda" {
  source = "../../../_templates/app_python_serverless"

  app_name                       = local.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
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