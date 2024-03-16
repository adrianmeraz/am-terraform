data "aws_default_tags" "main" {}

module "secrets" {
  source = "../../../modules/secrets"

  recovery_window_in_days        = 0 # Allows for instant deletes
  secret_map                     = var.secret_map
  secret_name_prefix             = "${var.app_name}/${var.environment}"
  force_overwrite_secrets        = var.force_overwrite_secrets
}

locals {
  secrets_map = module.secrets.secret_map

  app_name    = var.app_name
  environment = var.environment
  name_prefix = "${local.app_name}-${local.environment}"
  ecr = {
    image_tag: "latest"
  }
  ecs = {
    launch_type: var.ecs.launch_type
    memory_mb:   var.ecs.memory_mb
    vcpu:        var.ecs.vcpu
  }
}

module "network" {
  source = "../../../modules/network"

  cidr_block  = "10.0.0.0/16"
  name_prefix = local.name_prefix

  tags        = data.aws_default_tags.main.tags
}

resource "aws_ce_cost_allocation_tag" "main" {
  tag_key = "app_name"
  status  = "Active"
  depends_on = [
    module.network
  ]
}

locals {
  private_subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
}

module "alb_http" {
  source = "../../../modules/alb_http"

  environment = var.environment
  name_prefix = local.app_name

  app_container_port = 8080
  alb_tg_health_check = {
    interval            = 60
    enabled             = true
    path                = "/actuator/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  private_subnet_ids = local.private_subnet_ids
  security_group_ids = [module.network.security_group_id]
  vpc_id = module.network.vpc.id

  tags       = data.aws_default_tags.main.tags
}

module "apigw_logs" {
  source            = "../../../modules/logs"

  app_name         = local.app_name
  environment      = local.environment
  aws_service_name = "apigw"
  tags             = data.aws_default_tags.main.tags
}

module "apigw_ecs_http" {
  source = "../../../modules/apigwv2_ecs_http"

  environment              = var.environment
  name_prefix              = local.name_prefix

  aws_lb_listener_arn      = module.alb_http.http_aws_lb_listener_arn
  cloudwatch_log_group_arn = module.apigw_logs.cloudwatch_log_group_arn
  private_subnet_ids       = local.private_subnet_ids

  tags                     = data.aws_default_tags.main.tags
}

module "postgres_db" {
  source      = "../../../modules/rds_postgres"

  allocated_storage      = 20
  db_name                = "${local.app_name}${local.environment}"
  identifier             = local.name_prefix
  instance_class         = "db.t3.micro"
  password               = local.secrets_map["DB_PASSWORD"]
  private_subnet_ids     = local.private_subnet_ids
  username               = local.secrets_map["DB_USERNAME"]
  vpc_id                 = module.network.vpc.id
  vpc_security_group_ids = [module.network.security_group_id]

  tags                   = data.aws_default_tags.main.tags
}

module "ecr" {
  source = "../../../modules/ecr"

  name_prefix  = local.name_prefix
  force_delete = true

  tags         = data.aws_default_tags.main.tags
}

module "iam_ecs" {
  source = "../../../modules/iam_ecs"

  name_prefix = local.name_prefix

  tags         = data.aws_default_tags.main.tags
}
# Merging secrets from created resources with prior secrets map
module "secret_version" {
  # Only creates secrets if the secret string has changed
  source          = "../../../modules/secret_version"

  secret_id       = module.secrets.secretsmanager_secret_id
  secret_map      = merge(
    local.secrets_map,
    {
      "AWS_ECR_REGISTRY_NAME": module.ecr.name
      "AWS_ECR_REPOSITORY_URL": module.ecr.repository_url
      "DB_URL": module.postgres_db.jdbc_url
    }
  )
}

module "ecs_logs" {
  source            = "../../../modules/logs"

  app_name         = local.app_name
  environment      = local.environment
  aws_service_name = "ecs"
  tags             = data.aws_default_tags.main.tags
}

locals {
  container_name = "${local.name_prefix}-container"
}

module "ecs_container_definition" {
  source = "cloudposse/ecs-container-definition/aws"
  version = "0.61.1"

  container_cpu             = local.ecs.vcpu
  essential                 = true
  container_memory          = local.ecs.memory_mb
  container_name            = local.container_name
  container_image           = "${module.ecr.repository_url}:${local.ecr.image_tag}"
  log_configuration         = {
    logDriver = "awslogs"
    options   = {
      awslogs-group         = module.ecs_logs.cloudwatch_log_group.name
      awslogs-region        = var.aws_region # Get Region from data block
      awslogs-stream-prefix = local.name_prefix
    }
  }
  port_mappings = [
    {
      containerPort = 8080
      hostPort      = 8080
      name          = local.container_name
      protocol      = "tcp"
    }
  ]
  readonly_root_filesystem = false
  secrets = [for key, value in module.secret_version.secret_map: {name = key, valueFrom = "${module.secrets.arn}:${key}::"}]
}

module "ecs_task_definition" {
  source = "../../../modules/ecs_task_definition"

  name_prefix           = local.name_prefix
  container_definitions = <<EOF
    ${module.ecs_container_definition.json_map_encoded_list}
  EOF
  execution_role_arn    = module.iam_ecs.role_arn
  launch_type           = local.ecs.launch_type
  tags                  = data.aws_default_tags.main.tags
}

module "ecs_cluster_public" {
  source = "../../../modules/ecs_cluster_public"

  name_prefix         = local.name_prefix
  container_name      = local.container_name
  desired_count       = 1
  launch_type         = local.ecs.launch_type
  task_definition_arn = module.ecs_task_definition.arn
  vpc_id              = module.network.vpc.id
  lb_target_group_arn = module.alb_http.app_aws_lb_target_group_arn
  network_configuration = {
    assign_public_ip = true
    security_groups  = [module.network.security_group_id]
    subnets          = [for subnet in module.network.public_subnets: subnet.id]
  }
  tags               = data.aws_default_tags.main.tags
}
