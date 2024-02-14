locals {
  app_name = "expatmagic"
  base_tags = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
  ecr = {
    image_tag: "latest"
  }
  ecs = {
    launch_type: "FARGATE"
    memory_mb:   512
    vcpu:        256
  }
  environment = "dev"
  name_prefix = "${local.app_name}_${local.environment}"
  spring_active_profile = "dev"
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
  password = var.db.password
  subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
  username = var.db.username
  vpc_id = module.network.vpc.id
  vpc_security_group_ids = [module.network.security_group_id]

  tags = local.base_tags
}

module "secrets" {
  source = "../../../../modules/secrets"

  name                    = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map              = {
    "AWS_ACCESS_KEY":         var.aws_access_key,
    "AWS_REGION":             var.aws_region,
    "AWS_SECRET_KEY":         var.aws_secret_key,
    "DB_PASSWORD":            var.db.password,
    "DB_URL":                 module.postgres_db.jdbc_url,
    "DB_USERNAME":            var.db.username,
    "SPRING_PROFILES_ACTIVE": local.spring_active_profile
  }

  tags = local.base_tags
}

module "logs" {
  source            = "../../../../modules/logs"

  name              = local.name_prefix
  retention_in_days = 14

  tags              = local.base_tags
}

module "ecr" {
  source = "../../../../modules/ecr"

  name = local.name_prefix
  force_delete = true
  image_tag = local.ecr.image_tag

  tags = local.base_tags
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
  container_image           = module.ecr.repository_url
  log_configuration         = {
    logDriver = "awslogs"
    options   = {
      awslogs-group         = module.logs.log_group.name
      awslogs-region        = var.aws_region
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
  secrets = module.secrets.task_secrets
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


