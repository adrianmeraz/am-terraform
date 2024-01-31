variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "bucket" {
  description = "Name of s3 bucket"
  type        = string
}
