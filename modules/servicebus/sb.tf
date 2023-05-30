# sb.tf

locals {
  namespaces = flatten([
    for namespaces in var.config_yaml_file : [
      for namespace in namespaces : {
        "name" : namespace.name
        "options" : namespace.options
      }
    ]
  ])

}

resource "azurerm_servicebus_namespace" "this" {
  for_each = {
    for namespace in local.namespaces : namespace.name => namespace
    if can(namespace.name)
  }

  name                = each.key
  location            = var.rg_location
  resource_group_name = var.rg_name
  capacity            = try(each.value.options.capacity, null)
  sku                 = try(each.value.options.sku, "Standard")
  zone_redundant      = try(each.value.options.zone_redundant, null)

  timeouts {
    create = try(each.value.options.timeouts.create, null)
    delete = try(each.value.options.timeouts.delete, null)
    read   = try(each.value.options.timeouts.read, null)
    update = try(each.value.options.timeouts.update, null)
  }

  tags = {
    source = "terraform"
  }

}

# resource "azurerm_servicebus_topic" "topic" {
#   name         = "tfex_servicebus_topic"
#   namespace_id = azurerm_servicebus_namespace.example.id

#   enable_partitioning = true
# }
