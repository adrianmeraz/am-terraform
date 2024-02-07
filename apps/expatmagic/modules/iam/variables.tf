variable "name" {
  description = "Name of lambda role"
  type        = string
}

variable "secrets_manager_arn" {
  description = "Secrets manager arn"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
