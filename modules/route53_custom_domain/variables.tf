variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "api_gateway_id" {
  description = "ID of the API to connect."
  type        = string
}

variable "domain_name" {
  description = "Route 53 Domain name to create records and map to API Gateway. Default is generated API Gateway domain"
  type        = string
  default     = ""
}

variable "subdomain_name" {
  description = "Route 53 Subdomain name to create records and map to API Gateway. Default is generated API Gateway domain"
  type        = string
  default     = ""
}

variable "stage_name" {
  description = "Name of a specific deployment stage to expose at the given path. If omitted, callers may select any stage by including its name as a path element after the base path."
  type        = string
}
