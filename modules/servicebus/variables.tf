# servicebus/variables.tf

variable "resource_group_location" {
  description = <<EOF
        Specifies the supported Azure location where the resource exists.
        Changing this forces a new resource to be created. "
    EOF
  type        = string
}

variable "resource_group_name" {
  description = <<EOF
        The name of the resource group in which to create the Container Registry.
        Changing this forces a new resource to be created.
    EOF
  type        = string
}
