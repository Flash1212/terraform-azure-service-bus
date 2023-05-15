resource "azurerm_resource_group" "default_rg" {
  name     = "rg-${var.workload}-${var.env}-${var.location}"
  location = var.location
}
