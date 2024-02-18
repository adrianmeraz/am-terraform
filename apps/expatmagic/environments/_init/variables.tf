# TODO Add App name and other vars to pass in that change per environment

variable "secret_map" {
  description = "Map of secrets"
  type = map(string)
}