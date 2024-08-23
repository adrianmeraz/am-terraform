locals {
  name_prefix = "${var.app_name}-${var.environment}"
}

module "shared_cognito" {
  source = "../../../../modules/cognito"

  environment   = var.environment
  name_prefix   = local.name_prefix
  callback_urls = ["https://www.example.com/${var.environment}/cognito/callback"]
  logout_urls   = ["https://www.example.com/${var.environment}/cognito/logout"]
}

locals {
  secret_map = {
    "BASE_DOMAIN_NAME":         var.base_domain_name
    "COGNITO_POOL_ARN":         module.shared_cognito.pool_arn
    "COGNITO_POOL_CLIENT_ID":   module.shared_cognito.pool_client_id
    "COGNITO_POOL_ID":          module.shared_cognito.pool_id
    "COGNITO_POOL_NAME":        module.shared_cognito.pool_name
  }
}

module "shared_secrets" {
  source = "../../../../modules/secrets"

  recovery_window_in_days   = 0 # Allows for instant deletes
  secret_map                = local.secret_map
  secret_name_prefix        = "${var.app_name}/${var.environment}/shared"
}