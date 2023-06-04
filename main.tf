# main.tf

# Grant service principal access to keyvault
data "azurerm_client_config" "current" {}

# Collect additional users to add to keyvault
data "azuread_user" "user" {
  for_each = toset(var.user_mail)
  mail     = each.value
}

locals {
  #### Keyvault parameters
  # Enable/Disable Keyvault
  enable_keyvault = true
  # Merge service principal and additional users for keyvault access
  access_policy_objects = concat(local.imported_access_objects, local.service_principal_access_object)
  imported_access_objects = flatten([
    for user in data.azuread_user.user : {
      "object_id" = user.object_id,
      "tenant_id" = local.tenant_id
    }
  ])
  service_principal_access_object = [{
    "object_id" = data.azurerm_client_config.current.object_id,
    "tenant_id" = local.tenant_id
  }]
  tenant_id = data.azurerm_client_config.current.tenant_id

  #### Servicebus configuration
  config_yaml_file = yamldecode(file("./conf/config.yaml"))
}

module "azure_resource_group" {
  source = "./modules/resource-group/"

  env      = var.env
  location = var.location
  workload = var.workload
}

module "azure_servicebus" {
  source = "./modules/servicebus/"

  config_yaml_file = local.config_yaml_file
  rg_name          = module.azure_resource_group.rg_name
  rg_location      = module.azure_resource_group.rg_location

}

module "azure_key_vault" {
  source = "./modules/key-vault/"

  access_policy_objects      = local.access_policy_objects
  auth_rule_secrets          = module.azure_servicebus.service_bus_auth_rules
  enable_keyvault            = local.enable_keyvault == true ? true : false
  env                        = var.env
  rg_name                    = module.azure_resource_group.rg_name
  rg_location                = module.azure_resource_group.rg_location
  soft_delete_retention_days = 7
  tenant_id                  = local.tenant_id
  workload                   = var.workload
}
