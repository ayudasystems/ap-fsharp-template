# terraform/variables.tf

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

variable "resource_group_location" {
  default     = "North Central US"
  type        = string
  description = "Location of the resource group."
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription Id"
}

variable "azure_subscription_tenant_id" {
  type        = string
  description = "Azure Tenant Id"
}

variable "service_principal_appid" {
  type        = string
  description = "Azure Service Principal App Id"
}

variable "service_principal_password" {
  type        = string
  description = "Azure Service Principal Password"
}

variable "docker_registry_server_url" {
  type        = string
  description = "Docker Registry Server Hostname"
}

variable "docker_container_name" {
  type        = string
  description = "Docker Image Name to be used in App Service"
}

variable "docker_container_tag" {
  type        = string
  description = "Docker Container Tag version generated in previous build"
}

variable "service_plan_id" {
  type        = string
  description = "Linux Service Plan Id"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "Managed Identity ID to provide access to Terraform for pulling docker images from Container Registry"
}

variable "user_assigned_identity_client_id" {
  type        = string
  description = "Managed Identity Client ID to provide access to Terraform for pulling docker images from Container Registry"
}