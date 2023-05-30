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

module "azure_servicebus_namespace" {
  source = "./modules/servicebus/"

  config_yaml_file = local.config_yaml_file

}
