# terraform apply -var-file="eu-uat.terraform.tfvars"

environment             = "Ayuda Preview"
environment_suffix      = "-EU-UAT"
resource_group_name     = "ayudapreview-eu-01"
resource_group_location = "North Europe"
service_plan_name       = "ayudapreview-eu-serviceplan"
// repo_key = "" # To be introduced on the command line -var="repo_key=ap-fsharp-template"

