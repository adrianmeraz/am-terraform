variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "cloudwatch_log_group_arn" {
  description = "Cloudwatch Log Group ARN"
  type        = string
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}
