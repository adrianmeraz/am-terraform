variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "force_overwrite_secrets" {
  description = "Allows for forcing updates of secrets. Useful when new secrets are added"
  type        = bool
  default     = false
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}
