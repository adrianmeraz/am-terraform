variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "App Environment"
  type        = string
}

variable "name_prefix" {
  description = "Name to prefix all Cognito resources"
  type        = string
}

variable "allowed_oauth_flows" {
  description = "List of allowed OAuth flows (code, implicit, client_credentials)"
  type        = list(string)
  default = [
    "implicit",
    "code"
  ]
}

variable "allowed_oauth_scopes" {
  description = "List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin)"
  type        = list(string)
  default = [
    "aws.cognito.signin.user.admin",
    "email",
    "openid",
    "profile"
  ]
}

variable "explicit_auth_flows" {
  description = "List of authentication flows"
  type        = list(string)
  default = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]
}

variable "supported_identity_providers" {
  description = "List of provider names for the identity providers that are supported on this client"
  type        = list(string)
  default = [
    "COGNITO"
  ]
}

variable "callback_urls" {
  description = " List of allowed callback URLs for the identity providers. Where the user lands after a successful login."
  type        = list(string)
}

variable "logout_urls" {
  description = "List of allowed logout URLs for the identity providers. Where the user lands after a successful logout."
  type        = list(string)
}
