locals {
  app_name    = "expatmagic"
  environment = "prod"
  name_prefix = "${local.app_name}-${local.environment}"
}

module "cognito" {
  source = "../../../../modules/cognito"

  environment   = local.environment
  name_prefix   = local.name_prefix
  callback_urls = ["https://www.example.com/${local.environment}/cognito/callback"]
  logout_urls   = ["https://www.example.com/${local.environment}/cognito/logout"]
}