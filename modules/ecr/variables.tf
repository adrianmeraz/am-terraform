################################################################################
# Attributes
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The name of the ECR registry"
  type        = any
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