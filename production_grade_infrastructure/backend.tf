terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    tenant_id            = "f2a009da-b491-4dbb-94e8-5809162549cd"
    storage_account_name = "tfstate127878912"
    container_name       = "tf-state"
    key                  = "prod.terraform.tfstate"
  }
}