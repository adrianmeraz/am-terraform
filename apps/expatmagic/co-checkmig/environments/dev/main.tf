module "app" {
  source                  = "../../modules/app"
  app_name                = var.app_name
  aws_access_key          = var.aws_access_key
  aws_region              = var.aws_region
  aws_secret_key          = var.aws_secret_key
  environment             = var.environment
  force_overwrite_secrets = var.force_overwrite_secrets
  lambda_memory_MB        = 256
  secret_map              = var.secret_map
  shared_secret_id        = var.shared_secret_id
}
