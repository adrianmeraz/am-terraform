variable "app_name" {
  description = "Name of application"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = ""
}

variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
  default     = ""
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
  default     = ""
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package"
  type        = string
  default     = ""
}

variable "role" {
  description = "Amazon Resource Name (ARN) of the function's execution role."
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
  default     = ""
}
