locals {
  app_name             = "expatmagic"
  base_tags            = {
    "app_name" :    local.app_name
    "environment" : local.environment
  }
  environment           = "dev"
  name_prefix           = "${local.app_name}_${local.environment}"
  spring_active_profile = "dev"
}

module "secrets" {
  source = "../../../../modules/secrets"

  name                    = local.name_prefix
  recovery_window_in_days = 0 # Allows for instant deletes
  secret_map              = {
#    "AWS_ECR_REGISTRY_NAME":       module.ecr.name,
    "AWS_ECR_REGISTRY_NAME":       "CHANGE_ME",
#    "AWS_ECR_REPOSITORY_URL":      module.ecr.repository_url,
    "AWS_ECR_REPOSITORY_URL":      "CHANGE_ME",
    "CODECOV_TOKEN":               var.codecov_token,
    "DB_PASSWORD":                 var.db.password,
#    "DB_URL":                      module.postgres_db.jdbc_url,
    "DB_URL":                      "CHANGE_ME",
    "DB_USERNAME":                 var.db.username,
    "SPRING_PROFILES_ACTIVE":      local.spring_active_profile,
    "SPOOFER_PROXY_PASSWORD":      var.spoofer_proxy_password,
    "SPOOFER_PROXY_USERNAME":      var.spoofer_proxy_username,
    "TWO_CAPTCHA_API_KEY":         var.two_captcha_api_key,
    "TWO_CAPTCHA_CALLBACK_DOMAIN": var.two_captcha_callback_domain,
    "TWO_CAPTCHA_CALLBACK_TOKEN":  var.two_captcha_callback_token,
  }

  tags = local.base_tags
}