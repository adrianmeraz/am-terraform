locals {
  app_name            = "expatmagic"
  environment         = "dev"
  lambda = {
    memory_size: 512,
    # runtime: "java17",
    # handler: "com.dn.StreamLambdaHandler"
  }
}



# Add a private and public VPC. The public VPC subnet should have an internet gateway

module "vpc_public" {
  source = "../../../modules/vpc"

  app_name    = local.app_name
  environment = local.environment
}

module "internet_gateway" {
  source = "../../../modules/aws_internet_gateway"

  app_name    = local.app_name
  environment = local.environment

  vpc_id = module.vpc_public.id
}



module  "secrets_manager" {
  source = "../../../modules/secrets_manager"

  app_name    = local.app_name
  environment = local.environment
}

module  "secrets_manager" {
  source = "../../../modules/secrets_manager"

  app_name = local.app_name
  environment = local.environment

  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map = {
    "aws_access_key": var.aws_access_key,
    "aws_region": var.aws_region,
    "aws_secret_key": var.aws_secret_key,
    "db_password": var.db_password,
    "db_username": var.db_username
  }
}


module  "ecr" {
  source = "../../../modules/ecr"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name

  force_delete = true
  image_tag = "latest"
}

module "iam_role" {
  source = "../../../modules/lambda_role"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name
}

module "logs_iam_policy" {
  source = "../../../modules/logs_iam_policy"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name

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

  app_name = local.app_name
  environment = local.environment

  execution_role_arn = module.iam_role.arn
  image = module.ecr.repository_url_with_tag
  task = {
    cpu = 256
    memory = 512
  }
}

#module "lambda_function" {
#  source = "../../../modules/lambda_function"
#  app_name = local.app_name
#  environment = local.environment
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
  app_name    = local.app_name
  environment = local.environment

  allocated_storage = 20
  engine = "postgres"
  engine_version = "14.5"
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = var.db_password
  # password = module.secrets_manager.secret_map["db_password"]
  publicly_accessible = true
  username = var.db_username
  # username = module.secrets_manager.secret_map["db_username"]
}
