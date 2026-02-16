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
  subscription_id = ""
  features {}
}

provider "azuread" {
  tenant_id = ""
}