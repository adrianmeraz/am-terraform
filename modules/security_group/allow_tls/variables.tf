variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}

variable "cidr_ipv4" {
  description = "cidr block of ipv4"
  type        = string
}

variable "cidr_ipv6" {
  description = "cidr block of ipv6"
  type        = string
}
