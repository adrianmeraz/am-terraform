variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string
}

variable "parent_rest_api_id" {
  description = "ID of the associated Parent REST API"
  type        = string
}

variable "path_part" {
  description = "Last path segment of this API resource"
  type        = string
}

variable "resource_id" {
  description = "API resource ID"
  type        = string
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}

