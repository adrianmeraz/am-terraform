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

module "network" {
  source = "../../../../modules/network"

  cidr_block = "10.0.0.0/16"

  tags = local.base_tags
}

module "secrets_manager" {
  source = "../../../../modules/secrets_manager"

  name = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map = {
    "AWS_ACCESS_KEY": var.aws_access_key,
    "AWS_REGION": var.aws_region,
    "AWS_SECRET_KEY": var.aws_secret_key,
    "DB_PASSWORD": var.db.password,
    "DB_USERNAME": var.db.username
  }

  tags = local.base_tags
}

module  "ecr" {
  source = "../../../../modules/ecr"

  name = local.name_prefix
  force_delete = true
  image_tag = "latest"

  tags = local.base_tags
}

module "iam_role_lambda" {
  source = "../../../../modules/iam_role/lambda"

  name = local.name_prefix

  tags = local.base_tags
}

module "ecs_cluster" {
  source = "../../../../modules/ecs_cluster"

  name = local.name_prefix
  execution_role_arn = module.iam_role_lambda.arn
  image = module.ecr.repository_url_with_tag
  service = {
    desired_count = 1
    launch_type = local.ecs.launch_type
    network_configuration = {
      assign_public_ip = true
      subnets = [module.network.public_subnets]
    }
  }
  task = {
    vcpu = local.ecs.vcpu
    memory_mb = local.ecs.memory_mb
    secrets = module.secrets_manager.secret_map
  }
  tags = local.base_tags
}

module "postgres_db" {
  source      = "../../../../modules/database/postgres"

  allocated_storage = 20
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = var.db.password
  username = var.db.username
  vpc_security_group_ids = [module.network.security_group_id]

  tags = local.base_tags
}
