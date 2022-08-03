# terraform/container-registry.tf

# Linking container registry to access to docker images for deployment
resource "azurerm_container_registry" "cr" {
  name                = var.docker_registry_server_name
  resource_group_name = var.docker_registry_resource_group_name
  location            = azurerm_resource_group.app_plan_rg.location
  sku                 = "Standard"
  admin_enabled       = true
}