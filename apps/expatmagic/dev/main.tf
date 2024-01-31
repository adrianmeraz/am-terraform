locals {
  name_prefix       = "${var.app_name}_${var.environment}"
  base_tags         = {
    "app_name" : var.app_name
    "environment" : var.environment
  }
}


# Add a private and public VPC. The public VPC subnet should have an internet gateway

module "vpc" {
  source = "../../../modules/vpc"
  tags = local.base_tags

  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true
}

module "internet_gateway" {
  source = "../../../modules/internet_gateway"
  tags = local.base_tags

  vpc_id = module.vpc.id
}

module "aws_subnet_public" {
  source = "../../../modules/subnet"
  tags = local.base_tags
  availability_zone = var.aws_region
  cidr_block = "10.1.0.0/24"
  map_public_ip_on_launch = true

  vpc_id = module.vpc.id
}


#module  "secrets_manager" {
#  source = "../../../modules/secrets_manager"
#}

module  "secrets_manager" {
  source = "../../../modules/secrets_manager"
  tags = local.base_tags

  name = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map = {
    "aws_access_key": var.aws_access_key,
    "aws_region": var.aws_region,
    "aws_secret_key": var.aws_secret_key,
    "db_password": var.db.password,
    "db_username": var.db.username
  }
}


module  "ecr" {
  source = "../../../modules/ecr"
  tags = local.base_tags

  name = local.name_prefix

  force_delete = true
  image_tag = "latest"
}

module "iam_role" {
  source = "../../../modules/lambda_role"
  tags = local.base_tags

  name = local.name_prefix
}

module "logs_iam_policy" {
  source = "../../../modules/logs_iam_policy"
  tags = local.base_tags

  name = local.name_prefix
  path = "/"
}

resource "aws_iam_role_policy_attachment" "attach_logs_iam" {
  role       = module.iam_role.name
  policy_arn = module.logs_iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecs_task" {
  role       = module.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "ecs_cluster" {
  source = "../../../modules/ecs_cluster"
  tags = local.base_tags

  name = local.name_prefix
  execution_role_arn = module.iam_role.arn
  image = module.ecr.repository_url_with_tag
  task = {
    cpu = var.ecs.cpu
    memory = var.ecs.memory
  }
}

#module "lambda_function" {
#  source = "../../../modules/lambda_function"
#
#  function_name = "api"
#  # handler = local.lambda.handler
#  image_uri = "${module.ecr.repository_url_with_tag}"
#
#  memory_size = local.lambda.memory_size
#  package_type = "Image"
#  role = module.iam_role.arn
#  # runtime = local.lambda.runtime
#
#  # apply_on = "PublishedVersions"
#
#}

module "rds" {
  source      = "../../../modules/rds"
  tags = local.base_tags

  allocated_storage = 20
  engine = "postgres"
  engine_version = "14.5"
  identifier = var.app_name
  instance_class = "db.t3.micro"
  password = var.db.password
  # password = module.secrets_manager.secret_map["db_password"]
  publicly_accessible = true
  username = var.db.username
  # username = module.secrets_manager.secret_map["db_username"]
}
