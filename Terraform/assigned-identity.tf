# terraform/assigned-identity.tf

# Load an user identity in Terraform. These pieces of information will be used to give the correct right to your app service to pull images from the ACR.
resource "azurerm_user_assigned_identity" "uai" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = var.user_assigned_identity_name
}