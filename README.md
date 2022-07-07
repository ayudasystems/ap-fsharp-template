# ap-fsharp-template
The microservice fsharp template.

## Requirements
The project requires the following to be installed on your machine:
* .NET Core 6.0 ([download](https://dotnet.microsoft.com/download/dotnet-core))

## Technologies used
* `F#`
* `.Net Core`
* `Chocolatey`

## Working with it locally

## Set up a new Service
* Create a new repository in GitHub assigning `ap-fsharp-template`.
* Checkout new repository locally
* Create a new project in the repository with XXXXX template and assign Service Name in the template.
* Commit and push changes
* Set up new project using included config in CircleCI
Clone this repository

## Initialize the application

You can initialize the application either by running a script in the terminal or by creating new project in Rider
* In the `terminal`, go to the root directory of the solution and run the following command
`.\init.cmd`
or
`.\init.cmd [Solution name] [Project name] [Solution directory]`

* In `Rider`, 
  1. Click `File` -> `New` -> `More Templates`. 
  2. Click `Install Template...` and choose the base path of the template. 
  3. Click `Reload`.
  4. Find and click the `Broadsign FSharp Application` template in the left menu.
  5. Enter Solution name, Project name and Solution directory.
  6. Check `Put solution and project in the same directory`
  7. Click `Create`

## Run the application

In `Rider`, click `arrow`(run) or `bug`(debug) on the top right corner
* If the project does not run in Development environment check the `Run/Debug configurations` on the left of `arrow`

or
in command line execute the following commands in the base path.
`dotnet build`
`dotnet run`

## Terraform organisation
Folder: /FSharpTemplate/Terraform
* main.tf: configures the resources that make up your infrastructure.
* variables.tf: declares input variables for your dev and prod environment prefixes, and the AWS region to deploy to.
* terraform.tfvars: defines your region and environment prefixes. Terraform automatically loads variable values from any files that end in .tfvars
* outputs.tf: specifies the website endpoints for your dev and prod buckets.
* assets: houses your webapp HTML file.

Azure Resources
* resource-group
* app-service-plan
* app-service

## Terraform Commands
* `terraform init`: command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.
  (https://www.terraform.io/cli/commands/init)
* `terraform plan`: command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure
  (https://www.terraform.io/cli/commands/plan)
* `terraform apply`: command executes the actions proposed in a Terraform plan
  (https://www.terraform.io/cli/commands/apply)
* `terraform destroy`: command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
  (https://www.terraform.io/cli/commands/destroy)

## CircleCI
* .circleci/config.yml
* Terrafor Orb Documentation
https://circleci.com/developer/orbs/orb/circleci/terraform

## ARM Templates organisation
Folder: /FSharpTemplate/ARMTemplates
* artifacts/web.json: child template
* parent.json: parent template
* exportedtemplate.json: template exported from resource group
* first-template.json: first template without resources
* storage-account.json: template with specific storage account
* storage-account-reusable.json: added parameter to specify the storage account name
* parameters.dev.json: dev parameters json file
* parameters.prod.json: prod parameters json file

Azure resources
* storage account
* app service plan
* web app