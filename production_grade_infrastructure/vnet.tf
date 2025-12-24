# random name for load balancer domain name
resource "random_pet" "lb_hostname" {
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "prod_infrastructure_rg"
  location = "Canada Central"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "prod-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "Production"
  }
}

# Subnet inside the virtual network
resource "azurerm_subnet" "sub1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [ azurerm_virtual_network.vnet ]
}

# Network Security Group (NSG) for the subnet with security rules that allow access to the 
# applications running on the instances via ports 80 (HTTP) and 443 (HTTPS), 
# and permit SSH (port 22) access to the instances.
resource "azurerm_network_security_group" "sub1-nsg" {
  name                = "subnet1-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [ azurerm_subnet.sub1 ]

# http rule
security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

# https rule
  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  #ssh security rule
  security_rule {
    name                       = "allow-ssh"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the network security group with the subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.sub1-nsg.id
  depends_on = [ azurerm_subnet.sub1, azurerm_network_security_group.sub1-nsg ]
}

# public IP for load balancer
resource "azurerm_public_ip" "pip" {
  name                = "myPublicIP"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  zones               = ["1", "2"]
  domain_name_label   = "${random_pet.lb_hostname.id}"

  tags = {
    environment = "Production"
  }
}

# load balancer
resource "azurerm_lb" "lb" {
  name                = "ProdLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [ azurerm_public_ip.pip ]

  frontend_ip_configuration {
    name                 = "myPublicIP"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

# backend address pool for the load balancer
resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
  depends_on = [ azurerm_lb.lb ]
}

# Load balancer Probe to check the health of backend pool
resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  protocol        = "Http"
  request_path    = "/"
  port            = 80
  depends_on = [ azurerm_lb.lb ]
}

# Load Balancer rule
resource "azurerm_lb_rule" "example" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  probe_id                       = azurerm_lb_probe.example.id
  depends_on = [ azurerm_lb_backend_address_pool.example, azurerm_lb_probe.example ]
}

# Load Balancer nat rules to allow ssh access to the backend instances
resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id
  depends_on = [ azurerm_lb.lb, azurerm_lb_backend_address_pool.example ]
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "natpip" {
  name                = "NAT-PIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                = "prod-NatGateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"
}

# NAT Gateway association with Public IP
resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.natpip.id
  depends_on = [ azurerm_public_ip.natpip, azurerm_nat_gateway.nat ]
}

# NAT Gateway association with subnet
resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.sub1.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
  depends_on = [ azurerm_subnet.sub1, azurerm_nat_gateway.nat ]
}

# Bastion subnet for bastion host
resource "azurerm_subnet" "bastion_sub" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/27"]
  depends_on = [ azurerm_virtual_network.vnet ]
}

# Public IP for bastion host
resource "azurerm_public_ip" "bastionpip" {
  name                = "bastionpip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "prod_bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [ azurerm_subnet.bastion_sub, azurerm_public_ip.bastionpip]

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_sub.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}

# Network Security Group for the bastion subnet
resource "azurerm_network_security_group" "bastion-nsg" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [ azurerm_subnet.bastion_sub ]

  #ssh security rule
  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}