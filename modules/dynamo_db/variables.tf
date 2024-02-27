variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Name prefix for the table name"
  type        = string
}

variable "hash_key" {
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
}
