# terraform/application-insights.tf

# Create Storage Account for the project
resource "azurerm_storage_account" "sa" {
  name                     = "${var.docker_container_name}${var.environment_suffix_lowercase}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  access_tier              = "Hot"
}

# Create Log Storage Blob Container
resource "azurerm_storage_container" "lsc" {
  name                 = "${var.service_name}${var.environment_suffix}-logs"
  storage_account_name = azurerm_storage_account.sa.name
}

# Create Log Storage Blob Container SAS
data "azurerm_storage_account_blob_container_sas" "lscsas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  container_name    = azurerm_storage_container.lsc.name
  https_only        = true
  start             = "2022-07-05"
  expiry            = "2023-07-05"
  permissions {
    read   = true
    add    = true
    create = false
    write  = true
    delete = true
    list   = true
  }
  content_language = "en-US"
  content_type     = "application/json"
}