# kv.tf

resource "azurerm_key_vault" "this" {
  count    = var.enable_keyvault == true ? 1 : 0
  name     = "kv-${var.workload}-${var.env}-${var.rg_location}"
  location = var.rg_location

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  public_network_access_enabled   = var.public_network_access_enabled
  purge_protection_enabled        = var.purge_protection_enabled
  resource_group_name             = var.rg_name
  sku_name                        = var.akv_sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  tenant_id                       = var.tenant_id

  dynamic "access_policy" {
    for_each = {
      for k, account in var.access_policy_objects : k => account
    }
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id

      secret_permissions = [
        "Backup",
        "Delete",
        "Get",
        "List",
        "Purge",
        "Recover",
        "Restore",
        "Set"
      ]
    }

  }


  tags = {
    source = "terraform"
  }

}

resource "azurerm_key_vault_secret" "this" {
  for_each = {
    for rule in var.auth_rule_secrets : rule.name => rule
    if rule.export_to_keyvault != "false"
  }

  name         = each.key
  value        = jsonencode(each.value)
  key_vault_id = azurerm_key_vault.this[0].id
}
