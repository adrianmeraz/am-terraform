locals {
  app_name             = var.secret_map["APP_NAME"]
  aws_access_key       = var.secret_map["AWS_ACCESS_KEY"]
  aws_region           = var.secret_map["AWS_REGION"]
  aws_secret_key       = var.secret_map["AWS_SECRET_KEY"]

  base_tags            = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
  environment           = var.secret_map["APP_ENVIRONMENT"]
  name_prefix           = "${local.app_name}_${local.environment}"
}

module "secrets" {
  source = "../../../../modules/secrets"

  name                    = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map              = var.secret_map

  tags = local.base_tags
}