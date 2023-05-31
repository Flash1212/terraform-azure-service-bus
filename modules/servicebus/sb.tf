# modules/servicebus/sb.tf

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

  auth = flatten([
    for namespaces in var.config_yaml_file : [
      for namespace in namespaces : [
        for topic in namespace.topics : {
          "name"          = topic.name,
          "authorization" = topic.authorization,
        }
      ]
    ]
  ])

  subs = flatten([
    for namespaces in var.config_yaml_file : [
      for namespace in namespaces : [
        for topic in namespace.topics : [
          for subscription in topic.subscriptions : {
            "namespace" = namespace.name,
            "topic"     = topic.name,
            "name"      = subscription.name,
            "options"   = subscription.options,
          }
        ]
      ]
    ]
  ])

  queues = flatten([
    for namespaces in var.config_yaml_file : [
      for namespace in namespaces : [
        for queue in namespace.queues : {
          "namespace" = namespace.name,
          "name"      = queue.name
          "options"   = queue.options
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

resource "azurerm_servicebus_topic_authorization_rule" "this" {
  for_each = {
    for topic in local.auth : "${topic.name}-${topic.authorization.name}" =>
    merge(topic.authorization, { id = azurerm_servicebus_topic.this[topic.name].id })
    if can(topic.authorization.name)
  }

  name     = each.key
  topic_id = each.value.id
  listen   = try(each.value.listen, true)
  send     = try(each.value.send, true)
  manage   = try(each.value.manage, true)

  timeouts {
    create = try(each.value.timeouts.create, null)
    delete = try(each.value.timeouts.delete, null)
    read   = try(each.value.timeouts.read, null)
    update = try(each.value.timeouts.update, null)
  }

}

resource "azurerm_servicebus_subscription" "this" {
  for_each = {
    for subscription in local.subs : "${subscription.topic}.${subscription.name}" =>
    merge(subscription, { id = azurerm_servicebus_topic.this[subscription.topic].id })
    if can(subscription.name)
  }

  name                                      = each.key
  topic_id                                  = each.value.id
  auto_delete_on_idle                       = try(each.value.options.auto_delete_on_idle, null)
  client_scoped_subscription_enabled        = try(each.value.options.client_scoped_subscription_enabled, null)
  dead_lettering_on_filter_evaluation_error = try(each.value.options.dead_lettering_on_filter_evaluation_error, null)
  dead_lettering_on_message_expiration      = try(each.value.options.dead_lettering_on_message_expiration, null)
  default_message_ttl                       = try(each.value.options.default_message_ttl, null)
  enable_batched_operations                 = try(each.value.options.enable_batched_operations, null)
  forward_dead_lettered_messages_to         = try(each.value.options.forward_dead_lettered_messages_to, null)
  forward_to                                = try(each.value.options.forward_to, null)
  lock_duration                             = try(each.value.options.lock_duration, null)
  max_delivery_count                        = try(each.value.options.max_delivery_count, 1)
  requires_session                          = try(each.value.options.requires_session, null)
  status                                    = try(each.value.options.status, null)

  timeouts {
    create = try(each.value.options.timeouts.create, null)
    delete = try(each.value.options.timeouts.delete, null)
    read   = try(each.value.options.timeouts.read, null)
    update = try(each.value.options.timeouts.update, null)
  }

}

resource "azurerm_servicebus_queue" "this" {
  for_each = {
    for queue in local.queues : "${queue.namespace}-${queue.name}" =>
    merge(queue, { id = azurerm_servicebus_namespace.this[queue.namespace].id })
    if can(queue.name)
  }

  name                                    = each.key
  namespace_id                            = each.value.id
  auto_delete_on_idle                     = try(each.value.options.auto_delete_on_idle, null)
  dead_lettering_on_message_expiration    = try(each.value.options.dead_lettering_on_message_expiration, null)
  default_message_ttl                     = try(each.value.options.default_message_ttl, null)
  duplicate_detection_history_time_window = try(each.value.options.duplicate_detection_history_time_window, null)
  enable_batched_operations               = try(each.value.options.enable_batched_operations, null)
  enable_express                          = try(each.value.options.enable_express, null)
  enable_partitioning                     = try(each.value.options.enable_partitioning, null)
  forward_dead_lettered_messages_to       = try(each.value.options.forward_dead_lettered_messages_to, null)
  forward_to                              = try(each.value.options.forward_to, null)
  lock_duration                           = try(each.value.options.lock_duration, null)
  max_delivery_count                      = try(each.value.options.max_delivery_count, null)
  max_message_size_in_kilobytes           = try(each.value.options.max_message_size_in_kilobytes, null)
  max_size_in_megabytes                   = try(each.value.options.max_size_in_megabytes, null)
  requires_duplicate_detection            = try(each.value.options.requires_duplicate_detection, null)
  requires_session                        = try(each.value.options.requires_session, null)
  status                                  = try(each.value.options.status, null)

  timeouts {
    create = try(each.value.options.timeouts.create, null)
    delete = try(each.value.options.timeouts.delete, null)
    read   = try(each.value.options.timeouts.read, null)
    update = try(each.value.options.timeouts.update, null)
  }

}
