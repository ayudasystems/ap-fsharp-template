# Microservices template
The microservice fsharp template.

## Requirements
The project requires the following to be installed on your machine:
* .NET Core 6.0 ([download](https://dotnet.microsoft.com/download/dotnet-core))

## Technologies used
* `F#`
* `.Net Core`
* `Terraform`

## Set up a new Service
* Create a new repository in GitHub from template `ap-fsharp-template`.
* Checkout new repository locally
* In the `terminal`, go to the root directory of the solution and run the following command
  * For windows,
      `.\init.cmd` or `.\init.cmd [Solution name] [Project name]`
  * For linux/mac, update permission of init.sh by `chmod +x init.sh`, then run
    `./init.sh` or `./init.sh [Solution name] [Project name]`
* Define a CI/CD Pipeline deployment strategy (See CircleCI).
* Commit and push changes
* Set up new project using included config in CircleCI

## Run the application
In `Rider`, click `arrow`(run) or `bug`(debug) on the top right corner
* If the project does not run in Development environment check the `Run/Debug configurations` on the left of `arrow`

or
in command line execute the following commands in the base path.
`dotnet build`
`dotnet run`

## Terraform organisation
Folder: /Terraform
* main.tf: configures the resources that make up your infrastructure.
* providers.tf: declares cloud provider to deploy and credentials
* variables.tf: declares input variables for your dev and prod environment prefixes, and the AWS region to deploy to.
* terraform.tfvars: defines your region and environment prefixes. Terraform automatically loads variable values from any files that end in .tfvars
* outputs.tf: specifies the website endpoints for your dev and prod buckets.
* assets: houses your webapp HTML file.
* `<template>.tf`: Azure Resources Templates in the cloud provider. Please, check below available resources.

Azure Resources
* resource-group
* app-service-plan
* app-service
* application-insights
* log-analytic-workspace
* container-registry
* assigned-identity 
  * (User Assigned Identity requires an Azure Role Assignment 'AcrPull' for Container Registry with "Microsoft.ContainerRegistry/registries/pull/read" permissions)
 
## Terraform Commands
* `terraform init`: command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.
  (https://www.terraform.io/cli/commands/init)
* `terraform plan`: command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure
  (https://www.terraform.io/cli/commands/plan)
* `terraform apply`: command executes the actions proposed in a Terraform plan
  (https://www.terraform.io/cli/commands/apply)
* `terraform destroy`: DO NOT USE!!! command is a convenient way to destroy all remote objects managed by a particular Terraform configuration. It can cause platform deletes, try avoiding its use.  
  (https://www.terraform.io/cli/commands/destroy)

## CircleCI
* .circleci/config.yml
* Terraform Orb Documentation
https://circleci.com/developer/orbs/orb/circleci/terraform
* `Deployment strategy`:
  * Automatic Based Pipeline: Application will be deployed automatically to production environment. Any change will be promoted to Cloud environment automatically.
  ![docs/Automatic Based Pipeline.PNG](docs/Automatic Based Pipeline.PNG)
  * Approval Based Pipeline: Application will be deployed into Development environment. Promote to UAT and Production will require an approval.
  ![docs/Approval Based Pipeline.PNG](docs/Approval Based Pipeline.PNG)
