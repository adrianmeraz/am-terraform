locals {
  app_name = "expatmagic"
  base_tags = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
  ecs = {
    entry_point: ["java","-jar","/${local.app_name}.jar"]
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

module "secrets" {
  source = "../../../../modules/secrets"

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

module "iam" {
  source = "../../modules/iam/"

  name = local.name_prefix
  # secrets_manager_version_arn = module.secrets_manager.ssm_version_arn

  tags = local.base_tags
}

module "ecs_cluster" {
  source = "../../../../modules/ecs_cluster"

  name = local.name_prefix
  execution_role_arn = module.iam.role_arn
  image = module.ecr.repository_url_with_tag
  service = {
    desired_count = 1
    launch_type = local.ecs.launch_type
    network_configuration = {
      assign_public_ip = true
      security_groups = [module.network.security_group_id]
      subnet_ids = [for subnet in module.network.public_subnets: subnet.id]
    }
  }
  task = {
    entry_point = local.ecs.entry_point
    vcpu = local.ecs.vcpu
    memory_mb = local.ecs.memory_mb
    secrets = {
      secretsmanager_arn = module.secrets.secretsmanager.arn
      secretsmanager_name = module.secrets.secretsmanager.name
    }
  }
  vpc_id = module.network.vpc.id

  tags = local.base_tags
}

module "postgres_db" {
  source      = "../../../../modules/database/postgres"

  allocated_storage = 20
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = var.db.password
  subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
  username = var.db.username
  vpc_id = module.network.vpc.id
  vpc_security_group_ids = [module.network.security_group_id]

  tags = local.base_tags
}
