variable "github_org" {
  description = "Github Org"
  type        = string
}

variable "github_repository" {
  description = "Github Repository"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for role resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
