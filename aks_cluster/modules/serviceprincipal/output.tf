output "service_principal_object_id" {
  description = "The object id of service principal"
  value       = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  value = azuread_service_principal.main.application_tenant_id
}

output "client_id" {
  description = "The application id of the AzureAD application created."
  value       = azuread_application.main.client_id
}

output "client_secret" {
  description = "Password for the service principal."
  value       = azuread_service_principal_password.main.value
}