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

  topics = flatten([
    for namespaces in var.config_yaml_file : [
      for namespace in namespaces : [
        for topic in namespace.topics : {
          "namespace" = namespace.name,
          "name"      = topic.name,
          "options"   = topic.options,
        }
      ]
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

resource "azurerm_servicebus_topic" "this" {
  for_each = {
    for topic in local.topics : topic.name =>
    merge(topic, { id = azurerm_servicebus_namespace.this[topic.namespace].id })
    if can(topic.name)
  }

  name                                    = each.key
  namespace_id                            = each.value.id
  auto_delete_on_idle                     = try(each.value.options.auto_delete_on_idle, null)
  default_message_ttl                     = try(each.value.options.default_message_ttl, null)
  duplicate_detection_history_time_window = try(each.value.options.duplicate_detection_history_time_window, null)
  enable_batched_operations               = try(each.value.options.enable_batched_operations, null)
  enable_express                          = try(each.value.options.enable_express, null)
  enable_partitioning                     = try(each.value.options.enable_partitioning, null)
  max_message_size_in_kilobytes           = try(each.value.options.max_message_size_in_kilobytes, null)
  max_size_in_megabytes                   = try(each.value.options.max_size_in_megabytes, null)
  requires_duplicate_detection            = try(each.value.options.requires_duplicate_detection, null)
  status                                  = try(each.value.options.status, null)
  support_ordering                        = try(each.value.options.support_ordering, null)

  timeouts {
    create = try(each.value.options.timeouts.create, null)
    delete = try(each.value.options.timeouts.delete, null)
    read   = try(each.value.options.timeouts.read, null)
    update = try(each.value.options.timeouts.update, null)
  }

}


#   enable_partitioning = true
# }
