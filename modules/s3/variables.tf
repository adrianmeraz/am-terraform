variable "app_name" {
  description = "Name of application"
  type        = string
  default     = ""
}

variable "bucket" {
  description = "Name of s3 bucket"
  type        = string
  default     = null
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
