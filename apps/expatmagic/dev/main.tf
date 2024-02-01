locals {
  app_name = "expatmagic"
  base_tags         = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
  ecs = {
    cpu:    256
    memory: 512
  }
  environment = "dev"
  name_prefix = "${local.app_name}_${local.environment}"
  subnet = {
    availability_zone = "us-west-2a"
  }
  cidr = {
    all              = "0.0.0.0/0"
    vpc              = "10.0.0.0/16"
    public_subnets   = [
      "10.0.1.0/24",
      "10.0.2.0/24",
      "10.0.3.0/24",
      "10.0.4.0/24"
    ]
    private_subnets  = [
      "10.0.101.0/24",
      "10.0.102.0/24",
      "10.0.103.0/24",
      "10.0.104.0/24"
    ]
  }
}

# Add a private and public VPC. The public VPC subnet should have an internet gateway

module "vpc" {
  source = "../../../modules/vpc"
  tags = local.base_tags

  cidr_block = local.cidr.vpc

  enable_dns_hostnames = true
  enable_dns_support = true
}

module "internet_gateway" {
  source = "../../../modules/internet_gateway"
  tags = local.base_tags

  vpc_id = module.vpc.id
}

module "subnet_public" {
  source = "../../../modules/subnet"
  tags = local.base_tags

  availability_zone = local.subnet.availability_zone
  cidr_block = local.cidr.public_subnets[0]
  map_public_ip_on_launch = true
  vpc_id = module.vpc.id
}

module "subnet_private" {
  source = "../../../modules/subnet"
  tags = local.base_tags

  availability_zone = local.subnet.availability_zone
  cidr_block = local.cidr.private_subnets[0]
  map_public_ip_on_launch = false
  vpc_id = module.vpc.id
}


module "route_table" {
  source = "../../../modules/route_table"
  tags = local.base_tags

  route = {
    cidr_block = local.cidr.all
    gateway_id = module.internet_gateway.id
  }
  vpc_id = module.vpc.id
}

resource "aws_route_table_association" "this" {
  subnet_id      = module.subnet_public.id
  route_table_id = module.route_table.id
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
    "AWS_ACCESS_KEY": var.aws_access_key,
    "AWS_REGION": var.aws_region,
    "AWS_SECRET_KEY": var.aws_secret_key,
    "DB_PASSWORD": var.db.password,
    "DB_USERNAME": var.db.username
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
  service = {
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration = {
      assign_public_ip = true
      subnets = [module.subnet_public.id]
    }
  }
  task = {
    cpu = local.ecs.cpu
    memory = local.ecs.memory
    secrets = module.secrets_manager.secret_map
  }
}

module "rds" {
  source      = "../../../modules/rds"
  tags = local.base_tags

  allocated_storage = 20
  engine = "postgres"
  engine_version = "14.5"
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = var.db.password
  publicly_accessible = false
  username = var.db.username
  vpc_security_group_ids = [module.vpc.security_group_id]
}
