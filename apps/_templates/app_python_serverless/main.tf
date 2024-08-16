module "secrets" {
  source = "../../../modules/secrets"

  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map              = var.secret_map
  secret_name_prefix      = "${var.app_name}/${var.environment}"
}

module "mandatory_tags" {
  source = "../../../modules/mandatory_tags"

  app_name = var.app_name
  environment = var.environment
}

locals {
  secrets_map = module.secrets.secret_map

  app_name    = var.app_name
  environment = var.environment
  name_prefix = "${local.app_name}-${local.environment}"
  ecr = {
    image_tag: "latest"
  }
}

module "network" {
  source      = "../../../modules/network"

  cidr_block  = "10.0.0.0/16"
  name_prefix = local.name_prefix

  tags        = module.mandatory_tags.tags
}

resource "aws_ce_cost_allocation_tag" "main" {
  tag_key = "app_name"
  status  = "Active"
  depends_on = [
    module.network
  ]
}

module "ecr" {
  source = "../../../modules/ecr"

  name_prefix  = local.name_prefix
  force_delete = true

  tags         = module.mandatory_tags.tags
}

locals {
  private_subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
  public_subnet_ids = [for subnet in module.network.public_subnets: subnet.id]
}

module "iam_lambda_dynamo" {
  source      = "../../../modules/iam_lambda_dynamo"

  name_prefix = local.name_prefix

  tags        = module.mandatory_tags.tags
}

module "apigw_logs" {
  source            = "../../../modules/logs"
  depends_on = [
    module.iam_lambda_dynamo
  ]

  app_name         = local.app_name
  aws_service_name = "apigw"
  environment      = local.environment

  tags             = module.mandatory_tags.tags
}

# Merges app secrets with shared secrets
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
      "AWS_COGNITO_POOL_ID":        var.cognito_pool_id
      "AWS_COGNITO_POOL_CLIENT_ID": var.cognito_pool_client_id
      "AWS_DYNAMO_DB_TABLE_NAME":   var.dynamo_db_table_name
      "AWS_ECR_REGISTRY_NAME":      module.ecr.name
      "AWS_ECR_REPOSITORY_URL":     module.ecr.repository_url
      "ENVIRONMENT":                var.environment
    }
  )
}

data "aws_ecr_image" "latest" {
  depends_on = [module.ecr]
  repository_name = module.ecr.name
  most_recent     = true
}

module "lambdas" {
  source = "../../../modules/lambda_function_public"
  depends_on = [
    module.ecr
  ]

  for_each             = {for index, cfg in var.lambda_configs: cfg.module_name => cfg}

  app_name             = local.app_name
  env_aws_secret_name  = module.secrets.secretsmanager_secret_name
  environment          = local.environment
  http_method          = each.value.http_method
  image_config_command = "${var.lambda_cmd_prefix}.${each.value.module_name}.${var.lambda_handler_name}"
  image_uri            = "${module.ecr.repository_url}:${local.ecr.image_tag}"
  is_protected         = each.value.is_protected
  lambda_environment   = module.secret_version.secret_map
  lambda_module_name   = each.value.module_name
  memory_size          = var.lambda_memory_MB
  package_type         = "Image"
  path_part            = each.value.path_part
  role_arn             = module.iam_lambda_dynamo.role_arn
  source_code_hash     = split(":", data.aws_ecr_image.latest.image_digest)[1] # Use only hash without sha256: prefix
  timeout_seconds      = each.value.timeout_seconds

  tags                 = module.mandatory_tags.tags
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
  cognito_pool_arn         = var.cognito_pool_arn
  lambda_configs = [
    for idx, lambda in module.lambdas : {
      function_name      = lambda.function_name
      http_method        = lambda.http_method
      invoke_arn         = lambda.invoke_arn
      is_protected       = lambda.is_protected
      lambda_environment = lambda.lambda_environment
      path_part          = lambda.path_part
    }
  ]

  tags                     = module.mandatory_tags.tags
}


module "route53_custom_domain" {
  count          = var.domain_name != "" ? 1 : 0
  source         = "../../../modules/route53_custom_domain"
  depends_on = [
    module.apigw_lambda_http,
  ]

  api_gateway_id         = module.apigw_lambda_http.api_gateway_rest_api_id
  domain_name    = var.domain_name
  subdomain_name = var.app_name
  stage_name     = module.apigw_lambda_http.api_gateway_stage_name
}
