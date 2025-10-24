variable "app_name" {
  description = "App Name"
  type = string
}

variable "dynamo_db_config" {
  description = "DynamoDB Configuration"
  type        = object({
    hash_key_name       = string
    range_key_name      = string
    ttl_attr_name       = string
  })

  default = {
    hash_key_name       = "PK"
    range_key_name      = "SK"
    ttl_attr_name       = "ExpiresAt"
  }
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "lambda_cmd_prefix" {
  description = "Lambda command prefix"
  type        = string
}

variable "lambda_configs" {
  description = "List of lambda configs to setup integrations"
  type        = list(object({
    http_method          = string
    module_name          = string
    path_part            = string
    timeout_seconds      = number
  }))
}

variable "lambda_handler_name" {
  description = "Lambda handler name"
  type        = string
}

variable "lambda_memory_MB" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 256
}

variable "shared_app_name" {
  description = "Shared app name"
  type        = string
}

variable "secret_map" {
  description = "A map of secret keys and values"
  type        = map(string)
  default     = {}
}
