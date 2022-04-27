# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_app_service" "app_service" {
  name                = "ap-fsharp-template-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.sp.id
  source_control {
    repo_url           = "https://github.com/ayudasystems/ap-fsharp-template"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }

#  site_config {
#    dotnet_framework_version = "v4.0"
#    scm_type                 = "LocalGit"
#  }
#
#  app_settings = {
#    "SOME_KEY" = "some-value"
#  }
#
#  connection_string {
#    name  = "Database"
#    type  = "SQLServer"
#    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
#  }
}