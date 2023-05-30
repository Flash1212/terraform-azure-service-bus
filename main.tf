# main.tf

locals {
  yaml_sbm = yamldecode(file("${path.module}/modules/servicebus/config.yaml")).nameSpaces

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
