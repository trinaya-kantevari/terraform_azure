variable "location" {}

variable "resource_group_name" {}

variable "ssh_public_key" {
  default = "C:/Users/trinaya/.ssh/key.pub"
}

variable "client_id" {}

variable "client_secret" {
  type = string
  sensitive = true
}

variable "service_principal_name" {
  type = string
}