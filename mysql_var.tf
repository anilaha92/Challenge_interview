variable "userlogin" {
  default  = "dbadmin"
}

variable "admin_password" {
  default  = ""
  sensitive = true
}

variable "database_name" {
  default  = "kpmg"
}

variable "kv_sku_name" {
  default = "standard"
}
variable "mssql_server" {
  default  = "kpmgserver"
}

variable "kv_soft_delete_retention_days" {
  type = number
  default = 7
}
variable "azurerm_private_dns_zone_name" {default = "kpmg.mysql.database.azure.com"}

variable "az_private_dns_vnet_link_name" {default = "kpmgVnetZone.com"}

variable "az_mysql_flex_sku_name" {default = "GP_Standard_D2ds_v4"}

variable "backup_retention_days" {
  type = number
  default = 7
}
