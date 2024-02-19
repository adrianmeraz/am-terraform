locals {
  app_name    = "expatmagic"
  environment = "dev"
  name_prefix = "${local.app_name}_${local.environment}"

  base_tags = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
}

module "secrets" {
  source = "../../../../modules/secrets"

  name                    = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map              = var.secret_map

  tags = local.base_tags
}