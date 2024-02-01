variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of iam policy"
  type        = string
}

variable "path" {
  description = "Path of iam policy"
  type        = string
  default     = "/"
}
