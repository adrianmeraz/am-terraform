variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = string
  default     = 20
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "password" {
  description = "Password for the master DB user"
  type        = string
}

variable "subnet_ids" {
  description = "DB Subnet IDs"
  type        = list(string)
}

variable "username" {
  description = "Username for the master DB user."
  type        = string
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}

variable "vpc_security_group_ids" {
  description = ""
  type        = list(string)
}
