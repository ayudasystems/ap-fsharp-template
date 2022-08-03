# terraform/role-assignment.tf
# NOTE: This code is commented for future reference
# Reason: For Security restriction Azure Admin account will set up the Role to Pull images from Docker Container Registry to the User Assigned Identity
/*
resource "azurerm_role_assignment" "acrpull" {
  scope                = azurerm_container_registry.cr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}
*/