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
  aws_secretsmanager_secret_name = "expatmagic_dev/secret"
}

module "network" {
  source = "../../../../modules/network"

  cidr_block = "10.0.0.0/16"

  tags       = local.base_tags
}

data "aws_secretsmanager_secret" "this" {
  name = local.aws_secretsmanager_secret_name
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.id
}

locals {
  secrets_map = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)
}

module "postgres_db" {
  source      = "../../../../modules/database/postgres"

  allocated_storage = 20
  db_name = local.name_prefix
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = local.secrets_map['DB_PASSWORD']
  subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
  username = local.secrets_map['DB_USERNAME']
  vpc_id = module.network.vpc.id
  vpc_security_group_ids = [module.network.security_group_id]

  tags = local.base_tags
}

module "ecr" {
  source = "../../../../modules/ecr"

  name = local.name_prefix
  force_delete = true

  tags = local.base_tags
}

#module "secrets" {
#  source = "../../../../modules/secrets"
#
#  name                    = local.name_prefix
#  recovery_window_in_days = 0 # Allows for instant deletes
#  secret_map              = {
#    "AWS_ECR_REGISTRY_NAME":       module.ecr.name,
#    "AWS_ECR_REPOSITORY_URL":      module.ecr.repository_url,
#    "CODECOV_TOKEN":               var.codecov_token,
#    "DB_PASSWORD":                 var.db.password,
#    "DB_URL":                      module.postgres_db.jdbc_url,
#    "DB_USERNAME":                 var.db.username,
#    "SPRING_PROFILES_ACTIVE":      local.spring_active_profile,
#    "SPOOFER_PROXY_PASSWORD":      var.spoofer_proxy_password,
#    "SPOOFER_PROXY_USERNAME":      var.spoofer_proxy_username,
#    "TWO_CAPTCHA_API_KEY":         var.two_captcha_api_key,
#    "TWO_CAPTCHA_CALLBACK_DOMAIN": var.two_captcha_callback_domain,
#    "TWO_CAPTCHA_CALLBACK_TOKEN":  var.two_captcha_callback_token,
#  }
#
#  tags = local.base_tags
#}

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
  # TODO Merge ECS and DB JDBC into secrets!
  secrets = [for key, value in jsondecode(data.aws_secretsmanager_secret_version.this.secret_string): {name = key, valueFrom = "${data.aws_secretsmanager_secret_version.this.arn}:${key}::"}]
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


