# terraform/resource-group.tf

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.service_name}${var.environment_suffix}"
  location = var.resource_group_location
}
