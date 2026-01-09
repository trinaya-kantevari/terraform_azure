variable "rgname" {
  type        = string
  description = "resource group name"
  default = "aks-rg"

}

variable "location" {
  type    = string
  default = "canadacentral"
}

variable "service_principal_name" {
  type = string
  default = "trinaya-aks-sp"
}

variable "keyvault_name" {
  type = string
  default = "trinaya-aks-kv"
}

variable "SUB_ID" {
  type = string
}
