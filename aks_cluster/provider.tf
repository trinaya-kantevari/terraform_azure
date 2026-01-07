# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id = "ba942dc7-1b04-43b7-a56d-c2578e756591"
  features {}
}

provider "azuread" {
  tenant_id = "f2a009da-b491-4dbb-94e8-5809162549cd"
}