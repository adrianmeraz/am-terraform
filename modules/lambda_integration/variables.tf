variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cognito_authorizer_id" {
  description = "Cognito Authorizer"
  type        = string
  default     = ""
}

variable "http_method" {
  description = "HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = string
}

variable "is_authorized" {
  description = "Is protected by api gateway authorizer"
  type        = bool
}

variable "lambda_function_invoke_arn" {
  description = "ARN of Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of Lambda Function"
  type        = string
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}

variable "path_part" {
  description = "Last path segment of this API resource"
  type        = string
}

variable "root_resource_id" {
  description = "API Gateway root resource ID"
  type        = string
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string
}

variable "rest_api_execution_arn" {
  description = "Execution ARN of the associated REST API"
  type        = string
}