
variable "env" {
  description = "What environment is this for? ie: dev, qa, uat, prod"
  default     = "dev"
  type        = string
}

variable "location" {
  description = <<EOF
    Specifies the supported Azure location where the resource exists.
    Changing this forces a new resource to be created. "
    EOF
  default     = "westus2"
  type        = string
}

variable "workload" {
  description = <<EOF
    "What workload is this resource intended for? ie: keyvault, servicebus,
    apps, vms"
    EOF
  default     = "servicebus"
  type        = string
}

# variable "service_bus_namespaces" {
#   description = "Map of service bus namespaces."
# }

variable "serviceprinciple_id" {
  description = "The Client ID which should be used. to connect to Azure"
  type        = string
}

variable "serviceprinciple_key" {
  description = "The Client Secret which should be used to connecto to Azure"
  type        = string
}

variable "subscription_id" {
  description = "The subscription to be connected to."
  type        = string
}

variable "tenant_id" {
  description = <<EOF
        The Tenant ID for the Service Principal associated with the Managed Service
        Identity of this Container Registry.
        EOF
  type        = string
}
