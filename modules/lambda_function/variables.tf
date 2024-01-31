variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
  default     = null
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

variable "role" {
  description = "Amazon Resource Name (ARN) of the function's execution role."
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
  default     = null
}
