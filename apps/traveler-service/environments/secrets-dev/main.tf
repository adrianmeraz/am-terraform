locals {
  app_name    = "traveler-service"
  environment = "dev"
  name_prefix = "${local.app_name}-${local.environment}"
}

module "secrets" {
  source = "../../../../modules/secrets"

  name_prefix             = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map              = var.secret_map
}
