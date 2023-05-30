# outputs.tf

output "servicebus_namespace" {
  value = module.azure_servicebus.service_bus_namespaces
}
}

output "servicebus_namespace_ids" {
  value = module.azure_servicebus_namespace.service_bus_namespace_ids
}
