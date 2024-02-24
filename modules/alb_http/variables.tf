variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment"
  type = string
}

variable "app_container_port" {
  description = "App Container Port"
  type        = number
}

variable "alb_tg_health_check" {
  description = "alb target group health check config"
  type = object({
    interval            = number
    enabled             = bool
    path                = string
    port                = number
    protocol            = string
    healthy_threshold   = number
    unhealthy_threshold = number
  })

  default = {
    interval            = 60
    enabled             = true
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

variable "name_prefix" {
  description = "Name to prefix all API resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}

