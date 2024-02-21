variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "launch_type" {
  description = "Launch type of service"
  type        = string
}

variable "latest_image_hash" {
  description = "Digest hash of the latest image"
  type        = string
}

variable "memory_mb" {
  description = ""
  type        = number
  default     = 512
}

variable "name" {
  description = "Name of cluster"
  type        = string
}

variable "network_configuration" {
  description = "Variables for ecs network configuration"
  type = object({
    assign_public_ip = bool
    security_groups  = list(string)
    subnets          = list(string)
  })
}

variable "task_definition_arn" {
  description = "ARN of the task definition"
  type        = string
}

variable "vcpu" {
  description = ""
  type        = number
  default     = 256
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}