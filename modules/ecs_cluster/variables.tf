variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of cluster"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of Role to execute the task"
  type        = string
}

variable "image" {
  description = "The ECR image to deploy"
  type        = string
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

variable "task" {
  description = "Variables for ecs task"
  type = object({
    cpu = number
    memory = number
  })

  default = {
    cpu = 256 # 256 (.25 vCPU) https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
    memory = 512
  }
}
