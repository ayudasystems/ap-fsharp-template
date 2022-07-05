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
  name                 = "${var.docker_container_name}${var.environment_suffix_lowercase}-logs"
  storage_account_name = azurerm_storage_account.sa.name
}

# Create rotation resource
resource "time_rotating" "main" {
  rotation_rfc3339 = null
  rotation_years   = 1

  triggers = {
    end_date = null
    years    = 1
  }
}

# Create Log Storage Blob Container SAS
data "azurerm_storage_account_blob_container_sas" "lscsas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  container_name    = azurerm_storage_container.lsc.name
  https_only        = true
  start             = timestamp()
  expiry            = time_rotating.main.rotation_rfc3339
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