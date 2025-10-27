variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Name prefix for the budget"
  type        = string
}

variable "limit_amount" {
  description = "The amount of cost or usage being measured for a budget."
  type        = string
  default     = "20"
}

variable "subscriber_email_addresses" {
  description = "E-Mail addresses to notify"
  type        = list(string)
  default     = []
}
