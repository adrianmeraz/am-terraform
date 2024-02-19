data "aws_secretsmanager_secret" "this" {
  name = var.aws_secretsmanager_secret_name
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.id
}

locals {
  secrets_arn = data.aws_secretsmanager_secret_version.this.arn
  secrets_map = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)

  app_name = "expatmagic"
  environment = var.environment
  name_prefix = "${local.app_name}_${local.environment}"
  ecr = {
    image_tag: "latest"
  }
  ecs = {
    launch_type: var.ecs.launch_type
    memory_mb:   var.ecs.memory_mb
    vcpu:        var.ecs.vcpu
  }
  base_tags = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
}

module "network" {
  source = "../../../../modules/network"

  cidr_block = "10.0.0.0/16"

  tags       = local.base_tags
}

module "postgres_db" {
  source      = "../../../../modules/database/postgres"

  allocated_storage = 20
  db_name = local.name_prefix
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = local.secrets_map["DB_PASSWORD"]
  subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
  username = local.secrets_map["DB_USERNAME"]
  vpc_id = module.network.vpc.id
  vpc_security_group_ids = [module.network.security_group_id]

  tags = local.base_tags
}

locals {
  postgres_secrets = {
    "DB_URL": module.postgres_db.jdbc_url
  }
}

module "ecr" {
  source = "../../../../modules/ecr"

  name = local.name_prefix
  force_delete = true

  tags = local.base_tags
}

locals {
  ecr_secrets = {
    "AWS_ECR_REGISTRY_NAME": module.ecr.name
    "AWS_ECR_REPOSITORY_URL": module.ecr.repository_url
  }
}

module "logs" {
  source            = "../../../../modules/logs"

  name              = local.name_prefix
  retention_in_days = 14

  tags              = local.base_tags
}

module "iam" {
  source = "../../modules/iam/"

  name = local.name_prefix

  tags = local.base_tags
}

module "ecs_container_definition" {
  source = "cloudposse/ecs-container-definition/aws"
  version = "0.61.1"

  container_cpu             = local.ecs.vcpu
  essential                 = true
  container_memory          = local.ecs.memory_mb
  container_name            = "${local.name_prefix}_container"
  container_image           = "${module.ecr.repository_url}:${local.ecr.image_tag}"
  log_configuration         = {
    logDriver = "awslogs"
    options   = {
      awslogs-group         = module.logs.log_group.name
      awslogs-region        = var.aws_region # Get Region from data block
      awslogs-stream-prefix = local.name_prefix
    }
  }
  port_mappings = [
    {
      containerPort = 5000
      hostPort      = 5000
      name          = "ecs"
      protocol      = "tcp"
    }
  ]
  readonly_root_filesystem = false
  # TODO Merge ECS and DB JDBC into AWS secrets! Then merge just the secrets map

  secrets = [for key, value in local.secrets_map: {name = key, valueFrom = "${local.secrets_arn}:${key}::"}]
}

module "ecs_task_definition" {
  source = "../../../../modules/ecs_task_definition"

  name                  = "${local.name_prefix}_task"
  container_definitions = <<EOF
    ${module.ecs_container_definition.json_map_encoded_list}
  EOF
  execution_role_arn    = module.iam.role_arn
  launch_type           = local.ecs.launch_type
}

module "ecs_cluster" {
  source = "../../../../modules/ecs_cluster"

  name = "${local.name_prefix}_cluster"
  desired_count = 1
  launch_type = local.ecs.launch_type
  network_configuration = {
    assign_public_ip = true
    security_groups = [module.network.security_group_id]
    subnets = [for subnet in module.network.public_subnets: subnet.id]
  }
  task_definition_arn = module.ecs_task_definition.arn
  vpc_id = module.network.vpc.id

  tags = local.base_tags
}


