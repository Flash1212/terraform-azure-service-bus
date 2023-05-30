# key-valut/variables.tf

variable "access_policy_objects" {
  description = <<EOF
        A list of account objects (users/applications) to grant access to
        keyvault
    EOF

  type = list(object({
    tenant_id = string,
    object_id = string
  }))

}

variable "akv_sku_name" {
  default     = "standard"
  description = <<EOF
        The Name of the SKU used for this Key Vault. Possible values are
        `standard` and `premium`.
    EOF
  type        = string
}

variable "auth_rule_secrets" {
  description = <<EOF
        Output from services service_bus_auth_rules containing primary/secondary connection strings
    EOF
  type        = list(map(string))
}

variable "env" {
  description = "What environment is this for? ie: dev, qa, uat, prod"
  default     = "dev"
  type        = string
}

variable "enabled_for_deployment" {
  default     = false
  description = <<EOF
        Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets
        from the key vault.
    EOF
  type        = string
}

variable "enabled_for_disk_encryption" {
  default     = true
  description = <<EOF
        Boolean flag to specify whether Azure Disk Encryption is
        permitted to retrieve secrets from the vault and unwrap keys.
    EOF
  type        = string
}

variable "enabled_for_template_deployment" {
  default     = false
  description = <<EOF
        Boolean flag to specify whether Azure Resource Manager is permitted to
        retrieve secrets from the key vault.
    EOF
  type        = string
}

variable "enable_keyvault" {
  default     = true
  description = <<EOF
        To disable the creation of the keyvault set this to false or submit
        as false from main.tf.
    EOF
  type        = bool
}

variable "enable_rbac_authorization" {
  default     = false
  description = <<EOF
        Boolean flag to specify whether Azure Key Vault uses Role Based Access
        Control (RBAC) for authorization of data actions.
    EOF
  type        = string
}

variable "public_network_access_enabled" {
  default     = true
  description = <<EOF
        Whether public network access is allowed for this Key Vault. Defaults
        to true
    EOF
  type        = string
}

variable "purge_protection_enabled" {
  default     = false
  description = "Is Purge Protection enabled for this Key Vault?"
  type        = string
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

variable "soft_delete_retention_days" {
  default     = 7
  description = <<EOF
        The number of days that items should be retained for once soft-deleted.
        This value can be between 7 and 90 (the default) days.
    EOF
  type        = number
}

variable "tenant_id" {
  description = "The id of the tenant where keyvault will be created."
  type        = string

}
variable "workload" {
  description = <<EOF
        The prefix-name of the resource group in which to create the Container
        Registry. Changing this forces a new resource to be created.
    EOF
  type        = string
}
