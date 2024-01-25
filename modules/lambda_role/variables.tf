variable "app_name" {
  description = "Name of application"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name of lambda role"
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
