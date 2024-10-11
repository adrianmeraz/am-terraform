variable "app_name" {
  description = "App Name"
  type        = string
}

variable "environment" {
  description = "App Environment"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "secret_map" {
  description = "A map of secret keys and values"
  type        = map(string)
  default     = {}
}
