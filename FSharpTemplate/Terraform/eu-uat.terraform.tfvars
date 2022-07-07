# terraform apply -var-file="eu-uat.terraform.tfvars"

environment             = "Ayuda Preview"
environment_suffix      = "-EU-UAT"
resource_group_name     = "ayudapreview-eu-01"
resource_group_location = "North Europe"
service_plan_name       = "ayudapreview-eu-serviceplan"
service_plan_sku_name   = "P3v2"

