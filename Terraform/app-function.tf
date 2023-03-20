# terraform/app-function.tf

# Create a Function app service, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_windows_function_app" "af" {
  name                = "af-${var.service_name}${var.environment_suffix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = "/subscriptions/${var.azure_subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/serverfarms/${var.service_plan_name}"

  storage_account_name       = data.azurerm_storage_account.sa.name
  storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key

  app_settings = {
    https_only                                 = true
    AzureStorageConnectionString               = "${azurerm_storage_account.sa.primary_connection_string}"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE        = "false"
    WEBSITE_HEALTHCHECK_MAXPINGFAILURES        = 2
    APPINSIGHTS_INSTRUMENTATIONKEY             = "${azurerm_application_insights.ai.instrumentation_key}"
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "${azurerm_application_insights.ai.connection_string}"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    DiagnosticServices_EXTENSION_VERSION       = "~3"
    APPINSIGHTS_PROFILERFEATURE_VERSION        = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION        = "1.0.0"
    WEBSITE_RUN_FROM_PACKAGE                   = "1"
    FUNCTIONS_WORKER_RUNTIME                   = "dotnet"
    AzureWebJobsDisableHomepage                = true
  }

  site_config {
    cors {
      allowed_origins = [
        "https://as-${var.service_name}ui${var.environment_suffix}.azurewebsites.net",
        "https://localhost:8080"
      ]
    }
  }
  
  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_HEALTHCHECK_MAXPINGFAILURES"],
      app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"],
      app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      site_config["application_insights_connection_string"],
      site_config["application_insights_key"]
    ]
  }
}
