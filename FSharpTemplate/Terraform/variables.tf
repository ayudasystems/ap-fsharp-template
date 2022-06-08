# terraform/variables.tf

variable "project" {
  type = string
  description = "Project name"
}

variable "environment" {
  default = "Ayuda Dev"
  type = string
  description = "Environment (Ayuda Dev / Ayuda Preview / Ayuda Cloud)"
}

variable "environment_suffix" {
  default = "-NA-CI"
  type = string
  description = "Environment Suffix. E.g.: Ayuda Dev -> -NA-CI, Ayuda Preview -> -EU-UAT"
}

variable "resource_group_name" {
  default       = "ayudalabs-na-01"
  description   = "Name of the resource group."
}

variable "resource_group_location" {
  default = "North Central US"
  type = string
  description = "Location of the resource group."
}
