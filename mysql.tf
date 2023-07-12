resource "random_password" "mysqlpwd" {
  length           = 12
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
####### kv
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "azrm" {
  name                       = lower("${local.product_name}-kv")
  location                   = azurerm_resource_group.azrg.location
  resource_group_name        = azurerm_resource_group.azrg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku_name
  soft_delete_retention_days = var.kv_soft_delete_retention_days

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "azrm" {
  name         = var.userlogin
  value        = random_password.mysqlpwd.result
  key_vault_id = azurerm_key_vault.azrm.id
}

############

resource "azurerm_private_dns_zone" "azrg" {
  name                = var.azurerm_private_dns_zone_name
  resource_group_name = azurerm_resource_group.azrg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "azrg" {
  name                  = var.az_private_dns_vnet_link_name 
  private_dns_zone_name = azurerm_private_dns_zone.azrg.name
  virtual_network_id    = azurerm_virtual_network.network.id
  resource_group_name   = azurerm_resource_group.azrg.name
}

resource "azurerm_mysql_flexible_server" "test" {
  name                   = "${local.product_name}-${var.mssql_server}"
  location               = azurerm_resource_group.azrg.location
  resource_group_name    = azurerm_resource_group.azrg.name
  administrator_login    = var.userlogin
  administrator_password = local.mysqlpwd
  backup_retention_days  = var.backup_retention_days
  delegated_subnet_id    = azurerm_subnet.subnet3.id
  private_dns_zone_id    = azurerm_private_dns_zone.azrg.id
  sku_name               = var.az_mysql_flex_sku_name

  depends_on = [azurerm_private_dns_zone_virtual_network_link.azrg]
}