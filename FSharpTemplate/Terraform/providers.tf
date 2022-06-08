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
  client_id         = "771e6187-899a-4a94-b9ca-7ec66fa153e1" // "<service_principal_appid>"
  client_secret     = "aRr8Q~QVMrCgvobG60hULPuNgtOYfXiDc4DdfcDu" // "<service_principal_password>"
}
