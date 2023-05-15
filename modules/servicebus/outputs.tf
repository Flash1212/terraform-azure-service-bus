output "service_bus_namespace_name" {
  value = {
    for k, namespace in azurerm_servicebus_namespace.namespace : namespace.name => namespace.id
  }
}

output "service_bus_namespace_ids" {
    value = azurerm_servicebus_namespace.namespace[*].id
}
