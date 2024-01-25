locals {
  app_name          = "expatmagic"
  environment       = "dev"
  lambda_runtime    = "java17"
}

module  "ecr" {
  source = "../../../modules/ecr"

  name = local.app_name
  environment = local.environment
}

module "lambda_role" {
  source = "../../../modules/lambda_role"

  app_name = local.app_name
  name = local.app_name
  environment = local.environment
}

module "lambda_iam_policy" {
  source = "../../../modules/lambda_iam_policy"

  app_name = local.app_name
  name = local.app_name
  environment = local.environment

  path = "/"
  description = "AWS IAM Policy for managing aws lambda role"
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = module.lambda_role.name
  policy_arn  = module.lambda_iam_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  app_name                       = local.app_name
  filename                       = "${path.module}/python/hello-python.zip"

  function_name                  = "Spacelift_Test_Lambda_Function"
  role                           = module.lambda_iam_policy.arn
  handler                        = "index.lambda_handler"
  runtime                        = "python3.8"
  depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

module "lambda_function" {
  source = "../../../modules/lambda_function"
  app_name = local.app_name
  environment = local.environment

  function_name = "Expat Magic lambda function"
  handler = "com.dn.StreamLambdaHandler"
  image_uri = module.ecr.repository_url
  role = module.lambda_iam_policy.arn
  runtime = local.lambda_runtime
}
