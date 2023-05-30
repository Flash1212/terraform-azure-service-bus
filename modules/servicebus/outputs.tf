output "service_bus_namespaces" {
  value = {
    for k, namespace in azurerm_servicebus_namespace.this : namespace.name => namespace.id
  }
}

}

output "service_bus_namespace_ids" {
    value = azurerm_servicebus_namespace.namespace[*].id
}
