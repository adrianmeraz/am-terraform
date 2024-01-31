variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "instance_type" {
  description = "The instance size of the ec2 instance"
  type        = string
  default     = "t2.micro"
}

