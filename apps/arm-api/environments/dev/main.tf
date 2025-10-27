module "app" {
  source                  = "../../modules/app"
  app_name                = var.app_name
  environment             = var.environment
  budget_config           = var.budget_config
  github_org              = var.github_org
  github_repository       = var.github_repository
  lambda_memory_MB        = 256
  secret_map              = var.secret_map
  shared_app_name         = var.shared_app_name
}
