module "app" {
  source             = "../../modules/app"
  app_name           = var.app_name
  aws_access_key     = var.aws_access_key
  aws_region         = var.aws_region
  aws_secret_key     = var.aws_secret_key
  environment        = var.environment
  lambda_memory_MB   = 256
  lambda_environment = {
    "LOG_LEVEL": "DEBUG"
  }
  shared_secret_id   = var.shared_secret_id
}
