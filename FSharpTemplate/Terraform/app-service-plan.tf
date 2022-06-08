# terraform/app-service-plan.tf

# Create the Windows App Service Plan
resource "azurerm_service_plan" "sp" {
  name                = var.service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "P2v2"
}