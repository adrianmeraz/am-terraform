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

variable "domain_name" {
  description = "Custom domain name to use for API Gateway. Default is generated API Gateway domain"
  type        = string
  default     = ""
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
    is_protected         = bool
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
