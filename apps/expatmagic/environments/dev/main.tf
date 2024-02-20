module "app" {
  source = "../../modules/app"

  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  aws_secretsmanager_secret_name = var.aws_secretsmanager_secret_name
  environment                    = "dev"
  ecs = {
    launch_type: "FARGATE"
    memory_mb:   512
    vcpu:        256
  }
}