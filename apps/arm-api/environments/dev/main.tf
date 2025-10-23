module "app" {
  source                  = "../../modules/app"
  app_name                = var.app_name
  aws_access_key          = var.aws_access_key
  environment             = var.environment
  github_org              = var.github_org
  github_repository       = var.github_repository
  lambda_memory_MB        = 256
  secret_map              = var.secret_map
  shared_app_name         = var.shared_app_name
}
