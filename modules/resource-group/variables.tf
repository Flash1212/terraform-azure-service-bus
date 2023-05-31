# resource-group/variables.tf

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
        The prefix-name of the resource group in which to create the Container
        Registry. Changing this forces a new resource to be created.
    EOF
  type        = string
}
