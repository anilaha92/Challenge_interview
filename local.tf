#------------------------
# Local declarations
#------------------------
locals {
  location_name_mapping = {
    "East US" = "eus2"
  }
  location_label = local.location_name_mapping[var.region]
  product_name   = "${var.project}-${local.location_label}"
  mysqlpwd       = var.admin_password != "" ? var.admin_password : random_password.mysqlpwd.result
  vmpasswd       = var.password != "" ? var.password : random_password.vmpasswd.result
}
