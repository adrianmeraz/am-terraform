################################################################################
# Common Attributes
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Parameters
################################################################################

variable "cidr_block" {
  description = ""
  type        = string
}

variable "route" {
  description = "Route values"
  type = object({
    cidr_block = string
    gateway_id = string
  })
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}
