# terraform/storage-account.tf
resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}${var.storage_env_suffix}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      account_tier,
      account_replication_type
    ]
  }
}
