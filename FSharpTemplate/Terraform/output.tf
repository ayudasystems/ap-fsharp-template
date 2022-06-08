# terraform/outputs.tf

# Verify the results
# Define an output value in output.tf file
# Execute the following command in a console
#   echo "$(terraform output resource_group_name)"

# Example: Resource Group Name
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "service_plan_name" {
  value = azurerm_windows_web_app.app_service.name
  description = "Deployed Web App Service name"
}