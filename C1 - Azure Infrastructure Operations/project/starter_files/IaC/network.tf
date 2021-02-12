resource "azurerm_virtual_network" "main_vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

resource "azurerm_subnet" "internal_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}


resource "azurerm_subnet" "azure_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.0/27"]
}
/* resource "azurerm_network_interface" "main_nic" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal_subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.publicip.id
  }

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
} */

resource "azurerm_public_ip" "public_ip" {
  name                = "LoadBalancerIP"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allocation_method   = "Static"
  sku = "Standard"

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

resource "azurerm_public_ip" "outbound_public_ip" {
  name                = "Outbound_IP"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allocation_method   = "Static"
  sku = "Standard"

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion_ip"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allocation_method   = "Static"
  sku = "Standard"

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

resource "azurerm_network_security_group" "udacity_webserver_ingress_ng" {
  name                = "udacity_webserver_ng"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "allow_http_access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_application_security_group_ids = [azurerm_application_security_group.udacity_webserver_asg.id]
  }

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}

resource "azurerm_network_security_rule" "allow_vnet_ng_rule" {
  name                        = "allow_vnet_Access"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.udacity_webserver_ingress_ng.name
}

resource "azurerm_network_security_rule" "allow_internet_http_ng_rule" {
  name                        = "allow_vnet_Access"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.udacity_webserver_ingress_ng.name
}

resource "azurerm_network_security_rule" "deny_internetaccess_ng_rule" {
  name                        = "Deny_InternetAccess"
  priority                    = 115
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.udacity_webserver_ingress_ng.name
}

resource "azurerm_application_security_group" "udacity_webserver_asg" {
  name                = "udacity_webserver_asg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}