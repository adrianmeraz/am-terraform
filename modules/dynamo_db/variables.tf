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

variable "hash_key_name" {
  description = "Hash Key Name"
  type        = string
  default     = "PK"
}

variable "range_key_name" {
  description = "Range (Sort) Key Name"
  type        = string
  default     = "SK"
}

variable "ttl_attr_name" {
  description = "TTL Attribute Name"
  type        = string
  default     = "ExpiresAt"
}
