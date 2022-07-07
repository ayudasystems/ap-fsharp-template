# terraform/resource-group.tf

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create a virtual network within the resource group
#resource "azurerm_virtual_network" "vn" {
#  name                = "${azurerm_resource_group.rg.name}-vnet"
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  tags = {
#    "Customer" = "Stroeer"
#  }
#  address_space = [var.virtual_network_add]
#}