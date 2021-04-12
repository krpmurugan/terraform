output "container-instance-name" {
  value = azurerm_container_group.aci.name
}

output "container-instance-ip" {
  value = azurerm_container_group.aci.ip_address
}