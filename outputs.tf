output "servicebus_namespace_names" {
  value = module.azure_servicebus_namespace.service_bus_namespace_name
}

output "servicebus_namespace_ids" {
  value = module.azure_servicebus_namespace.service_bus_namespace_ids
}
