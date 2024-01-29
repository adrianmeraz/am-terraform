################################################################################
# Common Attributes
################################################################################

variable "app_name" {
  description = "Name of application"
  type        = string
}

variable "name" {
  description = "The name of the ECR registry"
  type        = any
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
# Lifecycle Policy
################################################################################

## Images
variable "image_tag_mutability" {
  description = "Determines whether a lifecycle policy will be created"
  type        = string
  default     = "MUTABLE"
}