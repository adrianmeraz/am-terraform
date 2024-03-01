variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "App Name"
  type = string
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "force_overwrite_secrets" {
  description = "Allows for forcing updates of secrets. Useful when new secrets are added"
  type        = bool
  default     = false
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
