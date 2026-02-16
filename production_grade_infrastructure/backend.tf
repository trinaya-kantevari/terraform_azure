terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    tenant_id            = "<tenant_id>" # your tenant id 
    storage_account_name = "tfstate127878912"
    container_name       = "tf-state"
    key                  = "prod.terraform.tfstate" # name of your state file inside the blob container
  }
}
