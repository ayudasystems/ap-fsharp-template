# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}

  // Service Principal
  // Using ap-terraform (not live - temp)
  subscription_id   = "b9f2d614-47a6-4974-9a3a-9d260db71e07" // "<azure_subscription_id>"
  tenant_id         = "baf00b3a-3dce-4b83-a82c-e4ffaee51f84" // "<azure_subscription_tenant_id>"
  client_id         = "5dd473cb-69e4-48d9-8220-f20410f25fde" // "<service_principal_appid>"
  client_secret     = "9b6cb4de-195f-4646-8e35-d3336a0ff6f5" // "<service_principal_password>"
}
