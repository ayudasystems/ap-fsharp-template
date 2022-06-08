# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_windows_web_app" "app_service" {
  name                = "ap-fsharp-template-${random_integer.ri.result}" //"ap-fsharp-template-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.sp.id

  site_config {}

#  app_settings = {
#    "SOME_KEY" = "some-value"
#  }

}