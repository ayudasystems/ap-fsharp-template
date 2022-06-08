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

variable "repo_key" {
  default     = "ap_fsharp-template"
  type        = string
  description = "Repository key"
}

variable "environment_suffix" {
  default     = "-NA-CI"
  type        = string
  description = "Environment Suffix. E.g.: Ayuda Dev -> -NA-CI, Ayuda Preview -> -EU-UAT"
}

variable "resource_group_name" {
  default       = "ayudalabs-na-01"
  description   = "Name of the resource group."
}

variable "resource_group_location" {
  default     = "North Central US"
  type        = string
  description = "Location of the resource group."
}

variable "service_plan_name" {
  default       = "ayudalabs-na-serviceplan"
  description   = "Name of the Service Plan."
}
