# main.tf

locals {
  yaml_sbm = yamldecode(file("${path.module}/modules/servicebus/config.yaml")).nameSpaces

#   name_spaces = local.yaml_sbm.nameSpaces[*].name
#   topics = { for ns in keys(local.yaml_sbm.nameSpaces[*].name):[
#     for topic in local.yaml_sbm.nameSpaces[ns].
#   ]

#   }
}

module "azure_resource_group" {
  source = "./modules/resource-group/"

  env      = var.env
  location = var.location
  workload = var.workload
}

module "azure_servicebus_namespace" {
  source = "./modules/servicebus/"

  resource_group_name     = module.azure_resource_group.resource_group_name
  resource_group_location = module.azure_resource_group.resource_group_location

}
