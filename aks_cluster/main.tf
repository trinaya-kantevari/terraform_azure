resource "azurerm_resource_group" "rg" {
  name = var.rgname
  location = var.location
}

module "serviceprincipal" {
  source = "./modules/serviceprincipal"
  service_principal_name = var.service_principal_name
  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_role_assignment" "rolesp" {
  scope                = "/subscriptions/${var.SUB_ID}"
  role_definition_name = "Contributor"
  principal_id         = module.serviceprincipal.service_principal_object_id
  depends_on = [ module.serviceprincipal ]
}

module "keyvault" {
  source = "./modules/keyvault"
  resource_group_name = var.rgname
  location = var.location
  keyvault_name = var.keyvault_name
}

resource "azurerm_key_vault_secret" "example" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id
  depends_on = [ module.keyvault, module.serviceprincipal]
}

module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.rgname
  depends_on = [ module.serviceprincipal ]
}

resource "local_file" "kubeconfig" {
  filename     = "./kubeconfig"
  content      = module.aks.config
  depends_on = [ module.aks ]
}