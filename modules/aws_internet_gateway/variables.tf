################################################################################
# Common Attributes
################################################################################

variable "app_name" {
  description = "Name of application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Parameters
################################################################################

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}
