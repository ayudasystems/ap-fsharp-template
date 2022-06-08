# Create the Linux App Service Plan
resource "azurerm_service_plan" "sp" {
  name                = "ayudalabs-na-serviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "P2v2"
}