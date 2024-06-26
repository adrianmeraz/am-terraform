data "aws_secretsmanager_secret_version" "shared" {
  secret_id = var.shared_secret_id
}

locals  {
  app_name           = "emcore"
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
      base_function_name   = "add-org-and-superuser"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.add_org_and_superuser_api.lambda_handler"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-organization"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.get_organization_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "add-member-user"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.add_member_user_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "add-staff-user"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.add_staff_user_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "add-superuser-user"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.add_superuser_user_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "get-user"
      http_method          = "GET"
      image_config_command = "${local.lambda_cmd_prefix}.get_user_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "add-traveler"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.add_traveler_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "delete-traveler"
      http_method          = "DELETE"
      image_config_command = "${local.lambda_cmd_prefix}.delete_traveler_api.lambda_handler"
      is_protected         = true
      timeout_seconds      = 10
    },
    {
      base_function_name   = "login"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.login_api.lambda_handler"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "refresh-token"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.refresh_token_api.lambda_handler"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      base_function_name   = "validate-user-email"
      http_method          = "POST"
      image_config_command = "${local.lambda_cmd_prefix}.validate_user_email_api.lambda_handler"
      is_protected         = false
      timeout_seconds      = 10
    }
  ]
}