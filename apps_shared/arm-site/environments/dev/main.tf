module "shared_cognito" {
  source = "../../../../modules/cognito"

  environment   = var.environment
  app_name      = var.app_name
  callback_urls = ["https://www.example.com/${var.environment}/cognito/callback"]
  logout_urls   = ["https://www.example.com/${var.environment}/cognito/logout"]
}

locals {
  secret_map = {
    "BASE_DOMAIN_NAME":             var.base_domain_name
    "AWS_COGNITO_POOL_ARN":         module.shared_cognito.pool_arn
    "AWS_COGNITO_POOL_CLIENT_ID":   module.shared_cognito.pool_client_id
    "AWS_COGNITO_POOL_ID":          module.shared_cognito.pool_id
    "AWS_COGNITO_POOL_NAME":        module.shared_cognito.pool_name
  }
}


module "shared_secrets" {
  source = "../../../../modules/ssm_parameter_store"

  app_name    = "shared/${var.app_name}"
  environment = var.environment
  secret_map  = local.secret_map
}
