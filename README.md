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

Clone this repository

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