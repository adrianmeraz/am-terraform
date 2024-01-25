variable "app_name" {
  description = "Name of application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Name of lambda role"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
