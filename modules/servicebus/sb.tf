# sb.tf

locals {
  yaml_sb= yamldecode(file("${path.module}/config.yaml")).nameSpaces
}

resource "azurerm_servicebus_namespace" "namespace" {
  count = length(local.yaml_sb)
  name                = local.yaml_sb[count.index].name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}

# resource "azurerm_servicebus_topic" "topic" {
#   name         = "tfex_servicebus_topic"
#   namespace_id = azurerm_servicebus_namespace.example.id

#   enable_partitioning = true
# }
