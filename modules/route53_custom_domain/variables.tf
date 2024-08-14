variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "api_id" {
  description = "ID of the API to connect."
  type        = string
}

variable "domain_main" {
  description = "Domain name for which the certificate should be issued"
  type        = string
}

variable "stage_name" {
  description = "Name of a specific deployment stage to expose at the given path. If omitted, callers may select any stage by including its name as a path element after the base path."
  type        = string
}
