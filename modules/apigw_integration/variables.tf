variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "http_method" {
  description = "HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = string
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
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

