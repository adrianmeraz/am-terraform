variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "lambda_configs" {
  description = "List of lambda configs to setup integrations"
  type          = list(object({
    base_function_name   = string
    http_method          = string
    image_config_command = string
  }))
}

variable "force_overwrite_secrets" {
  description = "Allows for forcing updates of secrets. Useful when new secrets are added"
  type        = bool
  default     = false
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}
