data "aws_secretsmanager_secret_version" "shared" {
  secret_id = "shared/${var.shared_app_name}/dev/secret"
}

locals  {
  shared_secret_map  = merge(jsondecode(data.aws_secretsmanager_secret_version.shared.secret_string))
  cognito_pool_name  = local.shared_secret_map["AWS_COGNITO_POOL_NAME"]
  cognito_pool_arn   = tolist(data.aws_cognito_user_pools.shared.arns)[0]
  cognito_pool_id    = tolist(data.aws_cognito_user_pools.shared.ids)[0]
}

data "aws_cognito_user_pool_clients" "shared" {
  user_pool_id = local.cognito_pool_id
}

locals {
  cognito_pool_client_id = tolist(data.aws_cognito_user_pool_clients.shared.client_ids)[0]
}

data "aws_cognito_user_pools" "shared" {
  name = local.cognito_pool_name
}
