variable "app_name" {
  description = "Name of application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Name of iam policy"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "path" {
  description = "Path of iam policy"
  type        = string
  default     = "/"
}
