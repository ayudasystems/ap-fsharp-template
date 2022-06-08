@REM TODO: Review path for Circle CI
SET TOOL_PATH="C:\ProgramData\chocolatey\lib\terraform\tools"

@REM Check Terraform Client availability
IF NOT EXIST "%TOOL_PATH%\terraform.exe" (
   @REM Install Terraform Client
   choco install terraform
)

SET TERRAFORM_PATH=./FSharpTemplate/Terraform

cd "%TERRAFORM_PATH"

@REM Login into Azure Platform using parameters
az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>
az account set --subscription <subscription_id_or_subscription_name>

@REM Execute deployment
terraform init
terraform plan
terraform apply
@REM <confirm_with_yes_to_perform_this_action>
@REM <check_resource_is_alive> -> curl 'https://ap-fsharp-template-na-ci.azurewebsites.net'
@REM terraform destroy
