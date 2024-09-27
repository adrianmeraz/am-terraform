locals {
  lambda_cmd_prefix      = "src.lambdas"
  lambda_handler_name    = "lambda_handler"
  lambda_timeout_seconds = 15
  lambda_configs = [
      {
        http_method     = "ANY"
        module_name     = "event_handler"
        path_part       = "{proxy+}"
        is_protected    = false
        timeout_seconds = local.lambda_timeout_seconds
      },
#     {
#       base_function_name   = "add-org-and-superuser"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.add_org_and_superuser_api.lambda_handler"
#       is_protected         = false
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "get-organization"
#       http_method          = "GET"
#       image_config_command = "${local.lambda_cmd_prefix}.get_organization_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "add-member-user"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.add_member_user_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "add-staff-user"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.add_staff_user_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "add-superuser-user"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.add_superuser_user_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "get-user"
#       http_method          = "GET"
#       image_config_command = "${local.lambda_cmd_prefix}.get_user_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "add-traveler"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.add_traveler_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "delete-traveler"
#       http_method          = "DELETE"
#       image_config_command = "${local.lambda_cmd_prefix}.delete_traveler_api.lambda_handler"
#       is_protected         = true
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "login"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.login_api.lambda_handler"
#       is_protected         = false
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "refresh-token"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.refresh_token_api.lambda_handler"
#       is_protected         = false
#       timeout_seconds      = 10
#     },
#     {
#       base_function_name   = "validate-user-email"
#       http_method          = "POST"
#       image_config_command = "${local.lambda_cmd_prefix}.validate_user_email_api.lambda_handler"
#       is_protected         = false
#       timeout_seconds      = 10
#     }
  ]
}


module "app_python_serverless" {
  source = "../../../../_templates/app_python_serverless"

  app_name                       = var.app_name
  aws_access_key                 = var.aws_access_key
  aws_region                     = var.aws_region
  aws_secret_key                 = var.aws_access_key
  environment                    = var.environment
  lambda_cmd_prefix              = local.lambda_cmd_prefix
  lambda_configs                 = local.lambda_configs
  lambda_handler_name            = local.lambda_handler_name
  lambda_memory_MB               = var.lambda_memory_MB
  secret_map                     = var.secret_map
  shared_app_name                = var.shared_app_name
}
