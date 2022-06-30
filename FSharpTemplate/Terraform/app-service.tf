# terraform/app-service.tf

# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_windows_web_app" "as" {
  name                = "${var.service_name}${var.environment_suffix}" // TODO: test deployment over deployment with the same name. Otherwise add  "${var.service_name}${var.environment_suffix}${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp.id

    app_settings = {
      DOCKER_REGISTRY_SERVER_USERNAME     = var.docker_registry_server_username
      DOCKER_REGISTRY_SERVER_PASSWORD     = var.docker_registry_server_password
      DOCKER_REGISTRY_SERVER_URL          = var.docker_registry_server_url
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    }

  site_config {

    application_stack {
      docker_container_name     = var.docker_container_name
      docker_container_tag      = var.docker_container_tag
    }

  }

}