resource "azurerm_lb" "udacity_lb" {
  name                = "udacity_load_balancer"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "Inbound"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  frontend_ip_configuration {
    name                 = "Outbound"
    public_ip_address_id = azurerm_public_ip.outbound_public_ip.id
  }

  depends_on = [ 
    azurerm_public_ip.public_ip
   ]

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )

}

resource "azurerm_lb_backend_address_pool" "udacity_lb_bap" {
  resource_group_name = azurerm_resource_group.main_rg.name
  loadbalancer_id     = azurerm_lb.udacity_lb.id
  name                = "BackEndAddressPool_Inbound"
}

resource "azurerm_lb_backend_address_pool" "udacity_lb_bap_outbound" {
  resource_group_name = azurerm_resource_group.main_rg.name
  loadbalancer_id     = azurerm_lb.udacity_lb.id
  name                = "BackEndAddressPool_Outbound"
}

resource "azurerm_lb_probe" "udacity_lb_probe" {
  resource_group_name = azurerm_resource_group.main_rg.name
  loadbalancer_id     = azurerm_lb.udacity_lb.id
  name                = "http-probe"
  port                = 80
}

resource "azurerm_lb_rule" "udacity_lb_rule" {
  resource_group_name            = azurerm_resource_group.main_rg.name
  loadbalancer_id                = azurerm_lb.udacity_lb.id
  name                           = "Udacity_LB_Rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  enable_tcp_reset               = true
  frontend_ip_configuration_name = "Inbound"
  probe_id = azurerm_lb_probe.udacity_lb_probe.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.udacity_lb_bap.id
}


resource "azurerm_lb_outbound_rule" "udacity_lb_outbound_rule" {
  resource_group_name            = azurerm_resource_group.main_rg.name
  loadbalancer_id                = azurerm_lb.udacity_lb.id
  name                           = "Udacity_LB_Outbound_Rule"
  protocol                       = "All"
  frontend_ip_configuration {
    name = "Outbound"
  }
  backend_address_pool_id = azurerm_lb_backend_address_pool.udacity_lb_bap_outbound.id
}