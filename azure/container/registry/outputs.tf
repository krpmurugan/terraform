
output "container-registry-name" {
  value = azurerm_container_registry.acr.name
}

output "container-registry-server-name" {
  value = azurerm_container_registry.acr.login_server
}

output "container-registry-admin-user-name" {
  value = azurerm_container_registry.acr.admin_username
}

output "container-registry-admin-password" {
  value = azurerm_container_registry.acr.admin_password
}