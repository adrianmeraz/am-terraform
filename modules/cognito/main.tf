resource "aws_cognito_user_pool" "main" {
  name = "${var.name_prefix}-pool"
  schema {
    name                     = "roles"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 512
    }
  }

  schema {
    name                     = "group"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 512
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}"
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "main" {
  name                                 = "${var.name_prefix}-client"
  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = false
  prevent_user_existence_errors        = "ENABLED"
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  explicit_auth_flows                  = var.explicit_auth_flows
  supported_identity_providers         = var.supported_identity_providers
  user_pool_id                         = aws_cognito_user_pool.main.id
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
}