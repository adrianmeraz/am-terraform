locals {
  app_name    = "expatmagic"
  environment = "dev"
  name_prefix = "${local.app_name}-${local.environment}"
}

module "shared_cognito" {
  source = "../../../../../modules/cognito"

  environment   = local.environment
  name_prefix   = local.name_prefix
  callback_urls = ["https://www.example.com/${local.environment}/cognito/callback"]
  logout_urls   = ["https://www.example.com/${local.environment}/cognito/logout"]
}

locals {
  secret_map = {
    "COGNITO_POOL_ID":  module.shared_cognito.pool_id
    "COGNITO_POOL_ARN": module.shared_cognito.pool_arn
  }
}

module "shared_secrets" {
  source = "../../../../../modules/secrets"

  recovery_window_in_days   = 0 # Allows for instant deletes
  secret_map                = local.secret_map
  secret_name_prefix        = "${local.app_name}/${local.environment}/shared"
  force_overwrite_secrets   = false
}