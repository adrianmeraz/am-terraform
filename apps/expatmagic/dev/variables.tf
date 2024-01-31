variable "app_name" {
  description = "Name of application"
  type        = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "db" {
  description = "Variables for database"
  type = object({
    username = string
    password = string
  })
}

variable "db_password" {
  type = string
}
variable "db_username" {
  type = string
}

variable "ecs" {
  description = "Variables for ecs cluster"
  type = object({
    cpu = number
    memory = number
  })

  default = {
    cpu = 256 # 256 (.25 vCPU) https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
    memory = 512
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
}
