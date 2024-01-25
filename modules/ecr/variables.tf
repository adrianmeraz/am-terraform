variable "app_name" {
  description = "Name of application"
  type        = string
  default     = ""
}

variable "name" {
  description = "The name of the ECR registry"
  type        = any
  default     = null
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = ""
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