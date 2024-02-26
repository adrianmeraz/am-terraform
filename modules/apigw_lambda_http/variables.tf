variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "aws_lb_listener_arn" {
  description = "ARN of the load balancer listener"
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "Cloudwatch Log Group ARN"
  type        = string
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}
