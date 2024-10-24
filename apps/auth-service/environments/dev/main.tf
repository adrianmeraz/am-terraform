module "app" {
  source                  = "../../modules/app"
  app_name                = var.app_name
  aws_access_key          = var.aws_access_key
  aws_region              = var.aws_region
  aws_secret_key          = var.aws_secret_key
  environment             = var.environment
  lambda_memory_MB        = var.lambda_memory_MB
  secret_map              = var.secret_map
  shared_app_name         = var.shared_app_name
}
