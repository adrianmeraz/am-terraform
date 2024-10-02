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

variable "secret_name_prefix" {
  description = "Secret name prefix i.e. 'appname/dev'"
  type        = string
}