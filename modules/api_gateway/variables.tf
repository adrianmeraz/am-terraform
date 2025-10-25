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

variable "lambda_configs" {
  description = "List of lambda configs to setup integrations"
  type          = list(object({
    function_name      = string
    http_method        = string
    invoke_arn         = string
    path_part          = string
    source_code_hash   = string
  }))
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}
