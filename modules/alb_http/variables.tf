variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}

