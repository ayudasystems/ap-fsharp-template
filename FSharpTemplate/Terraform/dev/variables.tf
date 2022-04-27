# Declares input variables for your dev and prod environment prefixes, and the Azure location to deploy to.

variable "resource_group_name" {
  default       = "ayudalabs-na-01"
  description   = "Name of the resource group."
}

variable "resource_group_location" {
  default = "North Central US"
  description   = "Location of the resource group."
}