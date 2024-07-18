variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "cloudwatch_log_group_arn" {
  description = "Cloudwatch Log Group ARN"
  type        = string
}

variable "cloudwatch_role_arn" {
  description = "Cloudwatch Role ARN"
  type        = string
}

variable "cognito_pool_arn" {
  description = "Cognito Pool ARN"
  type        = string
}

variable "lambda_configs" {
  description = "List of lambda configs to setup integrations"
  type          = list(object({
    env_log_level = string
    function_name = string
    http_method   = string
    invoke_arn    = string
    is_protected  = bool
    path_part     = string
  }))
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}
