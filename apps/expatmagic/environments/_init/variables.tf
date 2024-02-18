variable "aws_access_key" {
  description = "AWS Access Key ID"
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

variable "codecov_token" {
  description = "Codecov Token"
  type = string
}

variable "db" {
  description = "Database Credentials"
  type = object({
    username = string
    password = string
  })
}

variable "spoofer_proxy_password" {
  description = "Proxy password"
  type = string
}

variable "spoofer_proxy_username" {
  description = "Proxy username"
  type = string
}

variable "two_captcha_api_key" {
  description = "2Captcha API Key"
  type = string
}

variable "two_captcha_callback_domain" {
  description = "2Captcha Webhook Callback Domain"
  type = string
}

variable "two_captcha_callback_token" {
  description = "2Captcha Webhook Callback Token"
  type = string
}
