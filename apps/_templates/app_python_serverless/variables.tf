variable "app_name" {
  description = "App Name"
  type = string
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type = string
}

variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type = string
}

variable "dynamo_db_table_name" {
  description = "Dynamo DB Table Name"
  type = string
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "cognito_pool_arn" {
  description = "Shared cognito pool arn"
  type        = string
}

variable "cognito_pool_client_id" {
  description = "Shared cognito pool client id"
  type        = string
}

variable "cognito_pool_id" {
  description = "Shared cognito pool id"
  type        = string
}

variable "ecs" {
  description = "ECS task parameters"
  type = object({
    launch_type = string,
    memory_mb   = number,
    vcpu        = number
  })
  default = {
    launch_type = "FARGATE"
    memory_mb   = 512
    vcpu        = 256
  }
}

variable "force_overwrite_secrets" {
  description = "Allows for forcing updates of secrets. Useful when new secrets are added"
  type        = bool
  default     = false
}

variable "lambda_configs" {
  description = "List of lambda configs to setup integrations"
  type          = list(object({
    base_function_name   = string
    http_method          = string
    image_config_command = string
    is_protected         = bool
    lambda_environment   = map(string)
    timeout_seconds      = number
  }))
}

variable "memory_size_mb" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = bool
  default     = false
}

variable "runtime" {
  description = "Identifier of the function's runtime"
  type        = bool
  default     = false
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}

variable "security_group_ids" {
  description = "VPC Security Groups"
  type        = map(string)
  default     = {}
}
