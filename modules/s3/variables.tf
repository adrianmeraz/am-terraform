variable "app_name" {
  description = "Name of application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bucket" {
  description = "Name of s3 bucket"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
