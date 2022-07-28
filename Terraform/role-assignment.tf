resource "azurerm_role_assignment" "acrpull" {
  scope                = azurerm_container_registry.cr
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}