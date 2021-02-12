resource "azurerm_bastion_host" "azure_bastion" {
  name                = "azurebastion"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                 = "azurebastionconfiguration"
    subnet_id            = azurerm_subnet.azure_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }

  tags = merge (
    local.common_tags,
    map(
      "Contact", "Kita Shillingford"
    )
  )
}