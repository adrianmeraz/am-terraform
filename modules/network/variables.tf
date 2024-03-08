variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_counts" {
  description = "Number of subnets"
  type        = map(number)
  validation {
    condition = (var.subnet_counts.public > 0) && (var.subnet_counts.private > 1)
    error_message = "There must be at least 2 private and 1 public subnets."
  }
  default = {
    public  = 1,
    private = 2
  }
}
