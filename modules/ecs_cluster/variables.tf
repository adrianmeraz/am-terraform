variable "app_name" {
  description = "Name of application"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "image" {
  description = "The ECR image to deploy"
  type        = string
  default     = ""
}

variable "service" {
  description = "Variables for ecs service"
  type = object({
    launch_type = string
    desired_count = number
  })

  default = {
    launch_type = "FARGATE"
    desired_count = 0
  }
}

variable "task_cpu" {
  description = "Number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
  type        = number
  default     = 1
}

variable "task_memory" {
  description = "Amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  type        = number
  default     = 128
}
