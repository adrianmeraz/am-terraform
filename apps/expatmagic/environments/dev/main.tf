locals {
  app_name    = "expatmagic"
  environment = "dev"
}
module "app_spring_boot" {
  source = "../../../_templates/app_spring_boot"

  app_name                       = local.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  force_overwrite_secrets = var.force_overwrite_secrets
  environment                    = local.environment
  secret_map                     = var.secret_map
  ecs = {
    launch_type: "FARGATE"
    memory_mb:   512
    vcpu:        256
  }
}