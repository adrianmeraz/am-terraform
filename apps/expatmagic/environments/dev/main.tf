locals {
  app_name    = "expatmagic"
  environment = "dev"
}
module "app" {
  source = "../../modules/app"

  app_name                       = local.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  aws_secretsmanager_secret_name = var.aws_secretsmanager_secret_name
  environment                    = local.environment
  ecs = {
    launch_type: "FARGATE"
    memory_mb:   512
    vcpu:        256
  }
}