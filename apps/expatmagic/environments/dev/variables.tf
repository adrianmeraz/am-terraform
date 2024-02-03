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
