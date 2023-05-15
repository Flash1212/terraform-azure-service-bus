
output "resource_group_location" {
  value = azurerm_resource_group.default_rg.location
}

output "resource_group_name" {
  value = azurerm_resource_group.default_rg.name
}
