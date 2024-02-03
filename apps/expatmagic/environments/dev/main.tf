locals {
  app_name = "expatmagic"
  base_tags         = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
  ecs = {
    vcpu:        256
    launch_type: "FARGATE"
    memory_mb:   512
  }
  environment = "dev"
  name_prefix = "${local.app_name}_${local.environment}"
}

module "vpc" {
  source = "../../../../modules/vpc"
  tags = local.base_tags

  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true
}

module "secrets_manager" {
  source = "../../../../modules/secrets_manager"
  tags = local.base_tags

  name = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map = {
    "AWS_ACCESS_KEY": var.aws_access_key,
    "AWS_REGION": var.aws_region,
    "AWS_SECRET_KEY": var.aws_secret_key,
    "DB_PASSWORD": var.db.password,
    "DB_USERNAME": var.db.username
  }
}

module  "ecr" {
  source = "../../../../modules/ecr"
  tags = local.base_tags

  name = local.name_prefix

  force_delete = true
  image_tag = "latest"
}

module "iam_role_lambda" {
  source = "../../../../modules/iam_role/lambda"
  tags = local.base_tags

  name = local.name_prefix
}

module "ecs_cluster" {
  source = "../../../../modules/ecs_cluster"
  tags = local.base_tags

  name = local.name_prefix
  execution_role_arn = module.iam_role_lambda.arn
  image = module.ecr.repository_url_with_tag
  service = {
    desired_count = 1
    launch_type = local.ecs.launch_type
    network_configuration = {
      assign_public_ip = true
      subnets = [module.vpc.public_subnets]
    }
  }
  task = {
    cpu = local.ecs.vcpu
    memory = local.ecs.memory_mb
    secrets = module.secrets_manager.secret_map
  }
}

module "postgres_db" {
  source      = "../../../../modules/database/postgres"
  tags = local.base_tags

  allocated_storage = 20
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = var.db.password
  username = var.db.username
  vpc_security_group_ids = [module.vpc.security_group_id]
}
