variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Name prefix for the table name"
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "replica_region_name" {
  description = "Configuration block(s) with DynamoDB Global Tables V2 (version 2019.11.21) replication configurations"
  type        = string
}