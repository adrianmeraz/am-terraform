locals {
  app_name            = "expatmagic"
  environment         = "dev"
  lambda_memory_size  = 128
  lambda_runtime      = "java17"
  lambda_handler      = "com.dn.StreamLambdaHandler"
}

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

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = module.lambda_role.name
  policy_arn  = module.lambda_iam_policy.arn
}

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
