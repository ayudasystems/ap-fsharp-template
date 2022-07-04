# terraform/outputs.tf

# Verify the results
# Define an output value in output.tf file
# Execute the following command in a console
#   echo "$(terraform output resource_group_name)"

# Example: Resource Group Name
#output "resource_group_name" {
#  value       = azurerm_resource_group.rg.name
#  description = "Resource Group name"
#}
#
#output "service_plan_name" {
#  value       = azurerm_service_plan.sp.name
#  description = "Service Plan name"
#}

output "app_service_name" {
  value       = azurerm_linux_web_app.as.name
  description = "Deployed Web App Service name"
}