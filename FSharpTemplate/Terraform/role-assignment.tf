# terraform/role-assignment.tf

# Role assigment required to provide access to App Services for Container Registry
resource "azurerm_role_assignment" "acr" {
  scope                = azurerm_container_registry.cr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}