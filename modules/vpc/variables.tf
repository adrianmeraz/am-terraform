variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
  type        = string
  default     = ""
}

variable "enable_dns_support" {
  description = ""
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = ""
  type        = bool
  default     = false
}