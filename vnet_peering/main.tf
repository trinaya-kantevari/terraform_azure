# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "vnet-peering-rg"
  location = "Canada Central"
}

# Virtual Network 1
resource "azurerm_virtual_network" "vnet1" {
  name                = "network-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "staging"
  }
}

# Subnet inside the virtual network 1
resource "azurerm_subnet" "sub1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [ azurerm_virtual_network.vnet1 ]
}

# Virtual Network
resource "azurerm_virtual_network" "vnet2" {
  name                = "network-2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
  tags = {
    environment = "staging"
  }
}

# Subnet inside the virtual network
resource "azurerm_subnet" "sub2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/24"]
  depends_on = [ azurerm_virtual_network.vnet2 ]
}

resource "azurerm_virtual_network_peering" "peer-1-2" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "peer-2-1" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}