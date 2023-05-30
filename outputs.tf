# outputs.tf

output "servicebus_namespace" {
  value = module.azure_servicebus.service_bus_namespaces
}

output "servicebus_topics" {
  value = module.azure_servicebus.service_bus_topics
}

output "servicebus_auth_rules" {
  value     = module.azure_servicebus.service_bus_auth_rules
  sensitive = true
}

output "servicebus_subscriptions" {
  value = module.azure_servicebus.service_bus_subscriptions
}

}
