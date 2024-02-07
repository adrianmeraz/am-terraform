variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "execution_role_arn" {
  description = "ARN of Role to execute the task"
  type        = string
}

variable "image" {
  description = "The ECR image to deploy"
  type        = string
}

variable "name" {
  description = "Name of cluster"
  type        = string
}

variable "service" {
  description = "Variables for ecs service"
  type = object({
    launch_type = string
    desired_count = number
    network_configuration = object({
      assign_public_ip = bool
      security_groups = list(string)
      subnet_ids = list(string)
    })
  })
}

variable "container_definitions" {
  description = "ECS Task container definitions"
  type = list(object({}))
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

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}