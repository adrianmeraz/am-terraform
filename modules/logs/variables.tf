variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_service_name" {
  description = "AWS service name"
  type        = string
}

variable "group_name" {
  description = "Cloudwatch Group Name"
  type        = string
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 14
}
