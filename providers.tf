
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


terraform {
  backend "azurerm" {
    resource_group_name  = "ADO_RG"
    storage_account_name = "adostorage141"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate1"
  }
}


provider "azurerm" {
  features {}

  client_id       = "54cc9ba9-38f0-45f1-9f53-4ad3f45f5818"
  client_secret   = "63u8Q~8aIIyOLOCl1w6LWIUfV2c-oJ4ASc30zb0Y"
  tenant_id       = "215fa677-1490-4fdb-be3e-ffc1768808ea"
  subscription_id = "dc235f0a-d886-4e7d-a122-112f9b48ad18"
}