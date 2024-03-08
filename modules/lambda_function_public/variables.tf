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

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the function's execution role."
  type        = string
}

variable "source_code_hash" {
  description = "Identifier of the function's runtime."
  type        = string
  default     = ""
}
