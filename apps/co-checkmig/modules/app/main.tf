locals {
  lambda_cmd_prefix   = "src.lambdas"
  lambda_handler_name = "lambda_handler"
  lambda_configs = [
    {
      http_method          = "GET"
      module_name          = "api_bio_get_details"
      path_part            = "bio-get-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_bio_get_document_types_by_nationality"
      path_part            = "bio-get-document-types-by-nationality"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_bio_get_is_visa_required"
      path_part            = "bio-get-is-visa-required"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_bio_get_special_visa_types"
      path_part            = "bio-get-special-visa-types"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_bio_get_travel_reasons_by_nationality"
      path_part            = "bio-get-travel-reasons-by-nationality"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_bio_post_captcha_token_webhook"
      path_part            = "bio-post-captcha-token-webhook"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_bio_post_details"
      path_part            = "bio-post-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_lodging_get_cities"
      path_part            = "lodging-get-cities"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_lodging_get_details"
      path_part            = "lodging-get-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_lodging_post_details"
      path_part            = "lodging-post-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_pr_questions_get_details"
      path_part            = "pr-questions-get-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_pr_questions_post_details"
      path_part            = "pr-questions-post-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_pr_confirm_get_details"
      path_part            = "pr-confirm-get-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_pr_confirm_post_details"
      path_part            = "pr-confirm-post-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_pdf_post_details"
      path_part            = "pdf-post-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_travel_get_control_points"
      path_part            = "travel-get-control-points"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_travel_get_countries"
      path_part            = "travel-get-countries"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_travel_get_details"
      path_part            = "travel-get-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_travel_get_origin_cities"
      path_part            = "travel-get-origin-cities"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_travel_get_routes"
      path_part            = "travel-get-routes"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "POST"
      module_name          = "api_travel_post_details"
      path_part            = "travel-post-details"
      is_protected         = false
      timeout_seconds      = 10
    },
    {
      http_method          = "GET"
      module_name          = "api_twocaptcha_get_verification"
      path_part            = "2captcha.txt"
      is_protected         = false
      timeout_seconds      = 10
    }
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