variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret (0 is instant delete)"
  type        = number
  default     = 30
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