locals {
  app_name    = "traveler-service"
  environment = "dev"
}

module "app_python_lambda" {
  source = "../../../_templates/app_python_serverless"

  app_name                       = local.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  environment                    = local.environment
}