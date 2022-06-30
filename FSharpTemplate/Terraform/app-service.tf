# terraform/app-service.tf

# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_linux_web_app" "as" {
  name                = "${var.service_name}${var.environment_suffix}" // TODO: test deployment over deployment with the same name. Otherwise add  "${var.service_name}${var.environment_suffix}${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp.id

  app_settings = {
    #      DOCKER_REGISTRY_SERVER_USERNAME     = var.docker_registry_server_username
    #      DOCKER_REGISTRY_SERVER_PASSWORD     = var.docker_registry_server_password
    DOCKER_REGISTRY_SERVER_URL          = var.docker_registry_server_url
    DOCKER_CUSTOM_IMAGE_NAME            = "${var.docker_registry_server_url}/${var.docker_container_name}:${var.docker_container_tag}"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_HEALTHCHECK_MAXPINGFAILURES = 2
  }

  site_config {

    application_stack {
      docker_image     = "${var.docker_registry_server_url}/${var.docker_container_name}"
      docker_image_tag = var.docker_container_tag
    }

    #    windows_fx_version = "DOCKER|${azurerm_container_registry.cr.name}/${var.docker_container_tag}"
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.uai.client_id
    container_registry_use_managed_identity       = true
    health_check_path                             = "/api/health"

  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  logs {
    application_logs {
      file_system_level = "Information"
    }
  }

}