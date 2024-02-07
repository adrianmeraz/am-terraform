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

variable "task" {
  description = "Variables for ecs task"
  type = object({
    entry_point = list(string)
    vcpu = number
    memory_mb = number
    secrets = object({
      secretsmanager_arn = string
      secretsmanager_name = string
    })
  })

  default = {
    entry_point = ["java","-jar","/CHANGE_ME.jar"]
    vcpu = 256 # 256 (.25 vCPU) https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
    memory_mb = 512
    secrets = {
      secretsmanager_arn = null
      secretsmanager_name = null
    }
  }
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}