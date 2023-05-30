# modules/servicebuss/outputs.tf

output "service_bus_namespaces" {
  value = {
    for k, namespace in azurerm_servicebus_namespace.this : namespace.name => namespace.id
  }
}

output "service_bus_topics" {
  value = [
    for k, topics in azurerm_servicebus_topic.this : {
      "name" = topics.name,
      "id"   = topics.id
    }
  ]
}

output "service_bus_auth_rules" {
  value = [
    for k, auth_rules in azurerm_servicebus_topic_authorization_rule.this : {
      "name"                              = auth_rules.name
      "id"                                = auth_rules.id
      "primary_connection_string"         = auth_rules.primary_connection_string
      "primary_connection_string_alias"   = auth_rules.primary_connection_string_alias
      "primary_key"                       = auth_rules.primary_key
      "secondary_connection_string"       = auth_rules.secondary_connection_string
      "secondary_connection_string_alias" = auth_rules.secondary_connection_string_alias
      "secondary_key"                     = auth_rules.secondary_key
      "export_to_keyvault" = join(", ", [
        for topic in local.auth : try(topic.authorization.export_to_keyvault, true)
        if "${topic.name}-${topic.authorization.name}" == auth_rules.name
      ])
    }
  ]
}

output "service_bus_subscriptions" {
  value = [
    for k, subscriptions in azurerm_servicebus_subscription.this : {
      "name" = subscriptions.name,
      "id"   = subscriptions.id
    }
  ]
}

output "service_bus_namespace_ids" {
    value = azurerm_servicebus_namespace.namespace[*].id
}
