variable "app_name" {
  description = "App Name"
  type = string
}

variable "budget_limit_amount" {
  description = "Budget Config"
  type        = string
  default     = "20"
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "github_org" {
  description = "Github Org"
  type        = string
}

variable "github_repository" {
  description = "Github Repository"
  type        = string
}

variable "lambda_memory_MB" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 256
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
