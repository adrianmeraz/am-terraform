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

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}

variable "cidr_block" {
  description = ""
  type        = string
}

variable "map_public_ip_on_launch" {
  description = ""
  type        = bool
}

variable "availability_zone" {
  description = ""
  type        = string
}
