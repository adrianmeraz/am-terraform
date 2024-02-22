locals {
  app_name    = "expatmagic"
  environment = "dev"
  name_prefix = "${local.app_name}-${local.environment}"

  base_tags = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
}

module "secrets" {
  source = "../../../../modules/secrets"

  name_prefix                    = "${local.name_prefix}/secret"
  recovery_window_in_days        = 0 # Allows for instant deletes
  secret_map                     = var.secret_map

  tags = local.base_tags
}