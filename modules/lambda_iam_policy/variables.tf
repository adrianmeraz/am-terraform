variable "name" {
  description = "Name of iam policy"
  type        = string
  default     = ""
}

variable "path" {
  description = "Path of iam policy"
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description of iam policy"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
