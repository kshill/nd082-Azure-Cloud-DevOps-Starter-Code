data "azurerm_resource_group" "ubuntu_image_rg" {
  name = var.packerRG
}

data "azurerm_image" "ubuntu_image_packer" {
  name                = var.packerImageName
  resource_group_name = data.azurerm_resource_group.ubuntu_image_rg.name
}