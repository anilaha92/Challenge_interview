resource "azurerm_public_ip" "azrm" {
  name                = var.publicip
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "azrm" {
  name                = var.loadbalancer
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name

  frontend_ip_configuration {
    name                 = "${local.product_name}-PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.azrm.id
  }

  depends_on = [azurerm_public_ip.azrm]
}

resource "azurerm_lb_backend_address_pool" "azrm" {
  loadbalancer_id = azurerm_lb.azrm.id
  name            = var.BackEndAddressPool_name
}

resource "azurerm_lb_rule" "azrm" {
  loadbalancer_id                = azurerm_lb.azrm.id
  name                           = "${local.product_name}-LBRule"
  protocol                       = "Tcp"
  frontend_port                  = var.lb_frontend_port
  backend_port                   = var.lb_backend_port
  frontend_ip_configuration_name = "PublicIPAddress"
}
