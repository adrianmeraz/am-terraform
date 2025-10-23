locals {
  lambda_cmd_prefix      = "src"
  lambda_handler_name    = "handler"
  lambda_timeout_seconds = 15
  lambda_configs = [
    {
      http_method     = "ANY"
      module_name     = "main"
      path_part       = "{proxy+}"
      is_authorized   = false
      timeout_seconds = local.lambda_timeout_seconds
    },
  ]
}

module "app_python_serverless" {
  source = "../../../../_templates/app_python_serverless"

  app_name                       = var.app_name
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

module "mandatory_tags" {
  source = "../../../../modules/mandatory_tags"

  app_name    = var.app_name
  environment = var.environment
}

module "iam_gha_serverless" {
  source      = "../../../../modules/iam_github_actions_oidc"

  name_prefix       = var.app_name
  github_org        = var.github_org
  github_repository = var.github_repository

  tags              = module.mandatory_tags.tags
}