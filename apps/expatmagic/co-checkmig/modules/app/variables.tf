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

variable "environment" {
  description = "App Environment"
  type = string
}

variable "force_overwrite_secrets" {
  description = "Allows for forcing updates of secrets. Useful when new secrets are added"
  type        = bool
  default     = false
}

variable "lambda_memory_MB" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 256
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}

variable "shared_secret_id" {
  description = "ID of shared secrets"
  type = string
}
