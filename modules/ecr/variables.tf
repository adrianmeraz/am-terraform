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
# Parameters
################################################################################

variable "image_tag" {
  description = "Image Tag"
  type        = string
  default     = "latest"
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
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