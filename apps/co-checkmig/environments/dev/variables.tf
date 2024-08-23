variable "app_name" {
  description = "App Name"
  type = string
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type = string
}

variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type = string
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "shared_app_name" {
  description = "Shared app name"
  type        = string
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}
