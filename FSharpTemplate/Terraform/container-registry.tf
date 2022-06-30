# terraform/container-registry.tf

# Linking container registry to access to docker images for deployment
data "azurerm_container_registry" "cr" {
  name                = var.docker_registry_server_username
  resource_group_name = var.docker_registry_resource_group_name
}