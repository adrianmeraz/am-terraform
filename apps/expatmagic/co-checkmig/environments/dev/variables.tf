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

variable "domain_name" {
  description = "Custom domain name to use for API Gateway. Default is generated API Gateway domain"
  type        = string
  default     = ""
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}

variable "shared_secret_id" {
  description = "ID of shared secrets"
  type = string
}
