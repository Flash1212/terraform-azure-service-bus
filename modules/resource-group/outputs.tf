# resource-group/outputs.tf
output "rg_location" {
  value = azurerm_resource_group.default_rg.location
}

output "rg_name" {
  value = azurerm_resource_group.default_rg.name
}
