# terraform apply -var-file="na-ci.terraform.tfvars"

environment                         = "Ayuda Dev"
environment_suffix                  = "-NA-CI"
resource_group_name                 = "ayudalabs-na-01"
resource_group_location             = "North Central US"
service_plan_name                   = "ayudalabs-na-ci-serviceplan"
service_plan_sku_name               = "S1"
docker_registry_resource_group_name = "AyudaImageRegistry"
// service_name = "" # To be introduced on the command line -var="service_name=FSharpTemplate"

