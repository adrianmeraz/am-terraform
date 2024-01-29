locals {
  app_name            = "expatmagic"
  environment         = "dev"
  lambda_memory_size  = 128
  lambda_runtime      = "java17"
  lambda_handler      = "com.dn.StreamLambdaHandler"
}

# Setting secrets in secrets manager

module  "secrets_manager" {
  source = "../../../modules/secrets_manager"

  app_name = local.app_name
  environment = local.environment
  secret_map = {
    "aws_access_key": var.aws_access_key,
    "aws_region": var.aws_region,
    "aws_secret_key": var.aws_secret_key,
    "db_password": var.db_password,
    "db_username": var.db_username
  }
}

#resource "aws_secretsmanager_secret" "secrets" {
#  name = "${local.app_name}-${local.environment}"
#}

#resource "aws_secretsmanager_secret_version" "secrets_version" {
#  secret_id = aws_secretsmanager_secret.secrets.id
#  secret_string = <<EOF
#    {
#      "aws_access_key": "${var.aws_access_key},
#      "aws_region": "${var.aws_region},
#      "aws_secret_key": "${var.aws_secret_key},
#      "db_password": "${var.db_password},
#      "db_username": "${var.db_username}
#    }
#EOF
#}

module  "ecr" {
  source = "../../../modules/ecr"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name
}

module "lambda_role" {
  source = "../../../modules/lambda_role"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name
}

module "lambda_iam_policy" {
  source = "../../../modules/lambda_iam_policy"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name

  path = "/"
  description = "AWS IAM Policy for managing aws lambda role"
}

#resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
#  role        = module.lambda_role.name
#  policy_arn  = module.lambda_iam_policy.arn
#}

module "lambda_function" {
  source = "../../../modules/lambda_function"
  app_name = local.app_name
  environment = local.environment

  function_name = "api"
  handler = local.lambda_handler
  image_uri = "${module.ecr.repository_url}:latest"
  memory_size = local.lambda_memory_size
  package_type = "Image"
  role = module.lambda_role.arn
  runtime = local.lambda_runtime
}

module "rds" {
  source      = "../../../modules/rds"
  app_name    = local.app_name
  environment = local.environment

  allocated_storage = 20
  engine = "postgres"
  engine_version = "13.6"
  identifier = local.app_name
  instance_class = "db.t3.micro"
  password = var.db_password
  publicly_accessible = true
  username = var.db_username
}
