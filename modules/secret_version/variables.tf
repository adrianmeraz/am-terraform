variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_resource" {
  description = "Flag if secret version will be created"
  type        = bool
  default     = true
}

variable "secret_id" {
  description = "ID of secrets manager"
  type        = string
  default     = ""
}

variable "secret_map" {
  description = "A map of secret keys and values"
  type        = map(string)
  default     = {}
}
