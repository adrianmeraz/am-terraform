data "aws_secretsmanager_secret" "main" {
  name = var.aws_secretsmanager_secret_name
}

data "aws_secretsmanager_secret_version" "main" {
  secret_id = data.aws_secretsmanager_secret.main.id
}

data "aws_default_tags" "main" {}

locals {
  secrets_map = jsondecode(data.aws_secretsmanager_secret_version.main.secret_string)

  app_name    = var.app_name
  environment = var.environment
  name_prefix = "${local.app_name}-${local.environment}"
  ecr = {
    image_tag: "latest"
  }
  default_tags = data.aws_default_tags.main.tags
}

resource "aws_ce_cost_allocation_tag" "example" {
  tag_key = "app_name"
  status  = "Active"
}

module "network" {
  source = "../network"

  cidr_block = "10.0.0.0/16"

  tags       = local.default_tags
}

locals {
  private_subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
}

module "apigw_logs" {
  source            = "../logs"

  app_name     = local.app_name
  environment  = local.environment
  service_name = "apigw"
  tags         = local.default_tags
}

module "apigw_lambda_http" {
  source = "../apigw_lambda_http"

  environment              = var.environment
  name_prefix              = local.name_prefix

  cloudwatch_log_group_arn = module.apigw_logs.cloudwatch_log_group_arn
  private_subnet_ids       = local.private_subnet_ids

  tags                     = local.default_tags
}

module "ecr" {
  source = "../ecr"

  name_prefix  = local.name_prefix
  force_delete = true

  tags         = local.default_tags
}

module "iam_lambda" {
  source = "../iam_lambda_dynamo"

  name_prefix = local.name_prefix

  tags         = local.default_tags
}
# Merging secrets from created resources with prior secrets map
module "secret_version" {
  # Only creates secrets if the secret string has changed
  source          = "../secret_version"

  secret_id       = data.aws_secretsmanager_secret.main.id
  secret_map      = merge(
    local.secrets_map,
    {
      "AWS_ECR_REGISTRY_NAME": module.ecr.name
      "AWS_ECR_REPOSITORY_URL": module.ecr.repository_url
    }
  )
}
