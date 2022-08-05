# terraform/container-registry.tf

# Linking container registry to access to docker images for deployment
resource "azurerm_container_registry" "cr" {
  name                = var.docker_registry_server_name
  resource_group_name = var.docker_registry_resource_group_name
  location            = var.docker_registry_resource_group_location
  sku                 = "Standard"
  admin_enabled       = true

  lifecycle {
    prevent_destroy = true
  }
}