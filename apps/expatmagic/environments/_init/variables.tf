# TODO Add App name and other vars to pass in that change per environment

variable "aws_access_key" {
  description = "AWS Access Key"
  type = string
}

variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type = string
}

variable "secret_map" {
  description = "Map of secrets"
  type = map(string)
}