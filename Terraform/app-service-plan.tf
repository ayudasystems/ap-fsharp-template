# terraform/app-service-plan.tf

# Create App Service Plan
resource "azurerm_service_plan" "sp" {
  name                = var.service_plan_name
  location            = azurerm_resource_group.app_plan_rg.location
  resource_group_name = azurerm_resource_group.app_plan_rg.name
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name

  lifecycle {
    prevent_destroy = true
  }
}