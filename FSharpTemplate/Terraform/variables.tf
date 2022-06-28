# terraform/variables.tf

variable "project" {
  default     = "Ayuda Project FSharp Services Template"
  type        = string
  description = "Project name"
}

variable "environment" {
  default     = "Ayuda Dev"
  type        = string
  description = "Environment (Ayuda Dev / Ayuda Preview / Ayuda Cloud)"
}

variable "service_name" {
  default     = "FSharpTemplate"
  type        = string
  description = "New Service Name"
}

variable "environment_suffix" {
  default     = "-NA-CI"
  type        = string
  description = "Environment Suffix. E.g.: Ayuda Dev -> -NA-CI, Ayuda Preview -> -EU-UAT"
}

variable "resource_group_name" {
  default     = "ayudalabs-na-01"
  description = "Name of the resource group."
}

variable "resource_group_location" {
  default     = "North Central US"
  type        = string
  description = "Location of the resource group."
}

variable "service_plan_name" {
  default     = "ayudalabs-na-ci-serviceplan"
  description = "Name of the Service Plan."
}

variable "service_plan_sku_name" {
  default     = "S1"
  description = "Name of the Service Plan Pricing Tier."
}

variable "azure_subscription_id" {
  description = "Azure Subscription Id"
}

variable "azure_subscription_tenant_id" {
  description = "Azure Tenant Id"
}

variable "service_principal_appid" {
  description = "Azure Service Principal App Id"
}

variable "service_principal_password" {
  description = "Azure Service Principal Password"
}
