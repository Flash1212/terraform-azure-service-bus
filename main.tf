# main.tf

# Grant service principal access to keyvault
data "azurerm_client_config" "current" {}

# Collect additional users to add to keyvault
data "azuread_user" "user" {
  for_each = toset(var.user_mail)
  mail     = each.value
}

locals {
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
  config_yaml_file = yamldecode(file("./config.yaml"))
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

}
