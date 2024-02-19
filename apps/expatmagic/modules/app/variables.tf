variable "name" {
  description = "Name of lambda role"
  type        = string
}

#variable "secrets_manager_version_arn" {
#  description = "Secrets manager version arn"
#  type        = string
#}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
