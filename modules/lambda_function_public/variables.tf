variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "App Name"
  type = string
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "base_function_name" {
  description = "Base unique name for Lambda Function"
  type        = string
}

variable "http_method" {
  description = "Http Method for Lambda"
  type        = string
  validation {
    condition     = contains(["DELETE", "GET", "POST", "UPDATE"], var.http_method)
    error_message = "Valid values for var: http_method are (DELETE, GET, POST, UPDATE)."
  }
}

variable "image_config_command" {
  description = "Command for image"
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "package_type" {
  description = "Lambda deployment package type."
  type        = string
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package"
  type        = string
}

variable "is_protected" {
  description = "Is protected by api gateway authorizer"
  type        = bool
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the function's execution role."
  type        = string
}

variable "env_aws_secret_name" {
  description = "Environment Variable SSM Secret Name"
  type        = string
}

variable "env_log_level" {
  description = "Environment Variable Log Level"
  type        = string
  default     = "DEBUG"
}

variable "source_code_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash"
  type        = string
}

variable "timeout_seconds" {
  description = "Amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}
