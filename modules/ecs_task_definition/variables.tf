variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "execution_role_arn" {
  description = "ARN of Role to execute the task"
  type        = string
}

variable "launch_type" {
  description = "Launch Type of "
  type        = string
}

variable "name" {
  description = "Name of task definition"
  type        = string
}

variable "container_definitions" {
  description = "ECS Task container definitions"
  type = string
}

variable "vcpu" {
  description = ""
  type = number
  default = 256
}

variable "memory_mb" {
  description = ""
  type = number
  default = 512
}
