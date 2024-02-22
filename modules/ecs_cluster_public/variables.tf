variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "container_name" {
  description = "ECS Container Name"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "launch_type" {
  description = "Launch type of service"
  type        = string
}

variable "lb_target_group_arn" {
  description = "LB Target Group ARN"
  type        = string
}

variable "memory_mb" {
  description = ""
  type        = number
  default     = 512
}

variable "name_prefix" {
  description = "Name to prefix all ECS resources"
  type        = any
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