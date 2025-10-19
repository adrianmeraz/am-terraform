module "mandatory_tags" {
  source = "../../modules/mandatory_tags"

  app_name = var.app_name
  environment = var.environment
}

resource "aws_ce_cost_allocation_tag" "main" {
  tag_key = "app_name"
  status  = "Active"
}

locals {
  name_prefix = "${var.app_name}-${var.environment}"
  ecr = {
    image_tag: "latest"
  }
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix  = local.name_prefix
  force_delete = true

  tags         = module.mandatory_tags.tags
}

module "dynamo_db" {
  source = "../../modules/dynamo_db"

  name_prefix = local.name_prefix
}

module "iam_lambda_dynamo" {
  source      = "../../modules/iam_lambda_dynamo"

  name_prefix = local.name_prefix

  tags        = module.mandatory_tags.tags
}

module "apigw_logs" {
  source            = "../../modules/logs"
  depends_on = [
    module.iam_lambda_dynamo
  ]

  retention_in_days = 14
  group_name        = local.name_prefix
  aws_service_name  = "apigw"

  tags              = module.mandatory_tags.tags
}

data "aws_ecr_image" "latest" {
  depends_on = [module.ecr]
  repository_name = module.ecr.name
  most_recent     = true
}

module "shared_secrets" {
  source = "../../modules/shared_secrets"

  app_name    = var.shared_app_name
  environment = var.environment
}

# Secrets only created and stored the first run

module "secrets_ssm" {
  source = "../../modules/ssm"
  depends_on = [
    module.ecr
  ]

  secret_map = merge(
    module.shared_secrets.secret_map,
    var.secret_map,
    {
      "APP_NAME":                   var.app_name
      "AWS_DYNAMO_DB_TABLE_NAME":   module.dynamo_db.table_name
      "AWS_SECRET_NAME":            module.secrets_ssm.name
      "ENVIRONMENT":                var.environment
    }
  )
  app_name        = var.app_name
  environment     = var.environment
}

module "lambdas" {
  source = "../../modules/lambda_function_public"
  depends_on = [
    module.ecr,
  ]

  for_each             = {for index, cfg in var.lambda_configs: cfg.module_name => cfg}

  app_name             = var.app_name
  environment          = var.environment
  http_method          = each.value.http_method
  image_config_command = "${var.lambda_cmd_prefix}.${each.value.module_name}.${var.lambda_handler_name}"
  image_uri            = "${module.ecr.repository_url}:${local.ecr.image_tag}"
  is_authorized         = each.value.is_authorized
  lambda_env_var_map   = module.secrets_ssm.secret_map
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
  source = "../../modules/api_gateway"
  depends_on = [
    module.ecr,
    module.lambdas
  ]

  environment              = var.environment
  name_prefix              = local.name_prefix
  cloudwatch_log_group_arn = module.apigw_logs.cloudwatch_log_group_arn
  cloudwatch_role_arn      = module.iam_lambda_dynamo.role_arn
  cognito_pool_arn         = module.shared_secrets.cognito_pool_arn
  lambda_configs = [
    for idx, lambda in module.lambdas : {
      function_name      = lambda.function_name
      http_method        = lambda.http_method
      invoke_arn         = lambda.invoke_arn
      is_authorized      = lambda.is_authorized
      lambda_env_var_map = lambda.lambda_env_var_map
      path_part          = lambda.path_part
    }
  ]

  tags                     = module.mandatory_tags.tags
}

locals {
  domain_name = module.shared_secrets.base_domain_name
}

module "route53_custom_domain" {
  count          = local.domain_name != "" ? 1 : 0
  source         = "../../modules/route53_custom_domain"
  depends_on = [
    module.apigw_lambda_http,
  ]

  api_gateway_id = module.apigw_lambda_http.api_gateway_rest_api_id
  domain_name    = local.domain_name
  subdomain_name = local.name_prefix
  stage_name     = module.apigw_lambda_http.api_gateway_stage_name
}
