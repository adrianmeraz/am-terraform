module "secrets" {
  source = "../../../modules/secrets"

  app_name                  = var.app_name
  environment               = var.environment
  recovery_window_in_days   = 0 # Allows for instant deletes
  secret_map                = var.secret_map
  force_overwrite_secrets   = var.force_overwrite_secrets
}

data "aws_default_tags" "main" {}

locals {
  secrets_map = module.secrets.secret_map

  app_name    = var.app_name
  environment = var.environment
  name_prefix = "${local.app_name}-${local.environment}"
  default_tags = data.aws_default_tags.main.tags
  ecr = {
    image_tag: "latest"
  }
  lambda = {
    memory_size_mb = 128
  }
}

resource "aws_ce_cost_allocation_tag" "example" {
  tag_key = "app_name"
  status  = "Active"
}

module "network" {
  source = "../../../modules/network"

  cidr_block = "10.0.0.0/16"
  name_prefix = local.name_prefix

  tags       = local.default_tags
}

module "ecr" {
  source = "../../../modules/ecr"

  name_prefix  = local.name_prefix
  force_delete = true

  tags         = local.default_tags
}

locals {
  private_subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
  public_subnet_ids = [for subnet in module.network.public_subnets: subnet.id]
}

module "iam_lambda_dynamo" {
  source = "../../../modules/iam_lambda_dynamo"

  name_prefix = local.name_prefix

  tags        = local.default_tags
}

module "apigw_logs" {
  source            = "../../../modules/logs"
  depends_on = [
    module.iam_lambda_dynamo
  ]

  app_name         = local.app_name
  aws_service_name = "apigw"
  environment      = local.environment

  tags             = local.default_tags
}

data "aws_ecr_image" "latest" {
  repository_name = module.ecr.name
  most_recent       = true
}

module "lambdas" {
  source = "../../../modules/lambda_function_public"
  depends_on = [
    module.ecr
  ]

  for_each             = {for index, cfg in var.lambda_configs: cfg.base_function_name => cfg}

  app_name             = local.app_name
  base_function_name   = each.value.base_function_name
  environment          = local.environment
  http_method          = each.value.http_method
  image_config_command = each.value.image_config_command
  image_uri            = "${module.ecr.repository_url}:${local.ecr.image_tag}"
  memory_size          = local.lambda.memory_size_mb
  package_type         = "Image"
  role_arn             = module.iam_lambda_dynamo.role_arn
  source_code_hash     = split(":", data.aws_ecr_image.latest.image_digest)[1] # Use only hash without sha256: prefix

  tags                 = local.default_tags
}

module "cognito" {
  source = "../../../modules/cognito"

  environment   = var.environment
  name_prefix   = local.name_prefix
  callback_urls = ["https://www.example.com/dev/cognito/callback"]
  logout_urls   = ["https://www.example.com/dev/cognito/logout"]
}

module "apigw_lambda_http" {
  source = "../../../modules/apigw_lambda_with_auth"
  depends_on = [
    module.ecr,
    module.lambdas
  ]

  environment              = var.environment
  name_prefix              = local.name_prefix
  cloudwatch_log_group_arn = module.apigw_logs.cloudwatch_log_group_arn
  cloudwatch_role_arn      = module.iam_lambda_dynamo.role_arn
  cognito_pool_arn         = module.cognito.pool_arn
  lambda_configs = [
    for idx, lambda in module.lambdas : {
      function_name = lambda.function_name
      http_method   = lambda.http_method
      invoke_arn    = lambda.invoke_arn
      path_part     = lambda.base_function_name
    }
  ]

  tags = local.default_tags
}

# Merging secrets from created resources with prior secrets map
module "secret_version" {
  # Only creates secrets if the secret string has changed
  source          = "../../../modules/secret_version"
  depends_on = [
    module.ecr
  ]

  secret_id       = module.secrets.secretsmanager_secret_id
  secret_map      = merge(
    local.secrets_map,
    {
      "AWS_DYNAMO_DB_TABLE_NAME": var.dynamo_db_table_name
      "AWS_ECR_REGISTRY_NAME": module.ecr.name
      "AWS_ECR_REPOSITORY_URL": module.ecr.repository_url
    }
  )
}
