locals {
  app_name            = "expatmagic"
  environment         = "dev"
  lambda = {
    memory_size: 512,
    # runtime: "java17",
    # handler: "com.dn.StreamLambdaHandler"
  }
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
}

module "iam_role" {
  source = "../../../modules/lambda_role"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name
}

module "lambda_iam_policy" {
  source = "../../../modules/logs_iam_policy"

  app_name = local.app_name
  environment = local.environment
  name = local.app_name

  path = "/"
  description = "AWS IAM Policy for managing aws lambda role"
}

resource "aws_iam_role_policy_attachment" "lambda_iam_attachment" {
  role       = module.iam_role.name
  policy_arn = module.lambda_iam_policy.arn
}

module "lambda_function" {
  source = "../../../modules/lambda_function"
  app_name = local.app_name
  environment = local.environment

  function_name = "api"
  # handler = local.lambda.handler
  image_uri = "${module.ecr.repository_url}:latest"

  memory_size = local.lambda.memory_size
  package_type = "Image"
  role = module.iam_role.arn
  # runtime = local.lambda.runtime

  # apply_on = "PublishedVersions"

}

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
