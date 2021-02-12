resource "azurerm_resource_group" "main_rg" {
  name     = "${var.prefix}-resources"
  location = var.location

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.main_rg.name
  location                        = azurerm_resource_group.main_rg.location
  instances                       = var.instance_count
  sku                             = "Standard_D2s_v3"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false


  source_image_id = data.azurerm_image.ubuntu_image_packer.id
  

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = "udacity_webservers_nic"
    primary = true
    network_security_group_id = azurerm_network_security_group.udacity_webserver_ingress_ng.id


    ip_configuration {
      name                                   = "udacity_webserver_ipconfiguration"
      subnet_id                              = azurerm_subnet.internal_subnet.id
      application_security_group_ids = [azurerm_application_security_group.udacity_webserver_asg.id]
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.udacity_lb_bap.id,
        azurerm_lb_backend_address_pool.udacity_lb_bap_outbound.id
        ]
      primary = true
    }
  }


  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

