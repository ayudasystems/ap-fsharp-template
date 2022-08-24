# terraform/outputs.tf

# Verify the results
# Define an output value in output.tf file
# Execute the following command in a console

output "app_service_name" {
  value       = azurerm_linux_web_app.as.name
  description = "Deployed Web App Service name"
}

output "app_resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Deployed Resource Group name"
}
