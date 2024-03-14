resource "aws_cognito_user_pool" "main" {
  name = "${var.name_prefix}-pool"
}

resource "aws_cognito_user_pool_client" "main" {
  name                                 = "${var.name_prefix}-client"
  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = false
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  explicit_auth_flows                  = var.explicit_auth_flows
  supported_identity_providers         = var.supported_identity_providers
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls

  user_pool_id                         = aws_cognito_user_pool.main.id
}