variable "app_name" {
  description = "App Name"
  type = string
}

variable "environment" {
  description = "App Environment"
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

variable "ecs" {
  description = "ECS task parameters"
  type = object({
    launch_type = string,
    memory_mb   = number,
    vcpu        = number
  })
  default = {
    launch_type = "FARGATE"
    memory_mb   = 512
    vcpu        = 256
  }
}

variable "secret_map" {
  description = "Map of secrets"
  type        = map(string)
  default     = {}
}
