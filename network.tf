
resource "azurerm_resource_group" "azrg" {
  name     = upper("${local.product_name}-rg")
  location = var.region
}

resource "azurerm_virtual_network" "network" {
  name                = upper("${local.product_name}-vnet")
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
  address_space       = var.vnet_cidr
}


resource "azurerm_subnet" "subnet2" {
  name                 = upper("${local.product_name}-ext-snet")
  resource_group_name  = azurerm_resource_group.azrg.name
  address_prefixes     = var.subnet2_address_prefixes
  virtual_network_name = azurerm_virtual_network.network.name
}

resource "azurerm_subnet" "subnet3" {
  name                 = upper("${local.product_name}-mssql-snet")
  resource_group_name  = azurerm_resource_group.azrg.name
  address_prefixes     = var.subnet3_address_prefixes
  virtual_network_name = azurerm_virtual_network.network.name
  service_endpoints    = var.sub3_service_endpoints
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}


resource "azurerm_network_security_group" "subnet_nsg" {
  name                = upper("${local.product_name}-nsg")
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name

  security_rule {
    name                       = "${local.product_name}-inboundtest"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "subnet_nsg1" {
  name                = upper("${local.product_name}-mssql-nsg")
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name

  security_rule {
    name                       = "${local.product_name}-inbounddb"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso_2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.subnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso_3" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.subnet_nsg1.id
}
