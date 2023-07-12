resource "random_password" "vmpasswd" {
  length           = 12
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "azurerm_network_interface" "azrm" {
  name                = "${local.product_name}-nic"
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name

  ip_configuration {
    name                          = "${local.product_name}-nic"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "azrm" {
  name                  = "${local.product_name}-vm"
  location              = azurerm_resource_group.azrg.location
  resource_group_name   = azurerm_resource_group.azrg.name
  network_interface_ids = [azurerm_network_interface.azrm.id]
  vm_size               = var.vmsize
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  storage_os_disk {
    name              = var.diskname
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.managed_disk_type
  }
  os_profile {
    computer_name  = "${local.product_name}-webvm"
    admin_username = var.username
    admin_password = local.vmpasswd
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  /* custom_data = <<EOF
  #!/bin/bash

  echo "Hello Terraform! $(date +'%d/%m/%Y')" > op.txt
  apt update -y
  apt install nginx -y
  systemctl enable nginx
  systemctl start nginx
  EOF */

  tags = {
    environment = var.env
  }
}

