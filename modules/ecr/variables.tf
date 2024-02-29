################################################################################
# Attributes
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Name to prefix all ECR resources"
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


variable "image_tag_mutability" {
  description = "Determines whether a lifecycle policy will be created"
  type        = string
  default     = "MUTABLE"
}

variable "image_tag" {
  description = "Image tag used to push dummy image"
  type        = string
  default     = "latest"
}