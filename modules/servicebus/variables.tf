# # modules/servicebus/variables.tf

variable "config_yaml_file" {
  description = <<EOF
        A yaml configuration file containing the namespaces, topices, queus &
        subscriptions. This is a list of maps:

        ---
        - namespace:
            name: "name-space-1"
            topics:
              topic-a:
                options:
                  status: Active
                authorization:
                  name: topic-auth-rule
                subscriptions:
                  subscription-1:
                    options:
                      max_delivery_count: 1
                  subscription-2:
                    options:
                      max_delivery_count: 1
              topic-b:
                options:
                  status: Active
                authorization:
                  name: topic-auth-rule
                  listen: true
                  send: true
                  manage: true
                subscriptions:
                  subscription-1:
                    options:
                      max_delivery_count: 1
            queues:
              queue-1:
                status: Active
                timeouts:
                  create: 30m
                  delete: 30m
                  read: 5m
                  update: 30m
              queue-2:
                status: Active
    EOF
  #  TODO - type = list(object())
}

variable "rg_location" {
  description = <<EOF
        Specifies the supported Azure location where the resource exists.
        Changing this forces a new resource to be created. "
    EOF
  type        = string
}

variable "rg_name" {
  description = <<EOF
        The name of the resource group in which to create the Container Registry.
        Changing this forces a new resource to be created.
    EOF
  type        = string
}
