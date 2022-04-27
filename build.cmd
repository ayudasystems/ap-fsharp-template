@REM Authenticate to Azure via a Microsoft account
@REM az login
@REM az account set --subscription "<subscription_id_or_subscription_name>"

@REM Create a service principal???
@REM Connect-AzAccount
@REM Get-AzSubscription
@REM Set-AzContext -Subscription "<subscription_id_or_subscription_name>"
@REM $sp = New-AzADServicePrincipal -DisplayName <service_principal_name> -Role "Contributor"
@REM $sp.AppId
@REM $sp.PasswordCredentials.SecretText

@REM Assign a service principal
@REM $env:ARM_CLIENT_ID="<service_principal_app_id>"
@REM $env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
@REM $env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
@REM $env:ARM_CLIENT_SECRET="<service_principal_password>"

@REM
SET TOOL_PATH="C:\ProgramData\chocolatey\lib\terraform\tools"

IF NOT EXIST "%TOOL_PATH%\terraform.exe" (
   choco install terraform
)

SET TERRAFORM_PATH=./FSharpTemplate/Terraform

cd "%TERRAFORM_PATH"

terraform init
terraform apply
<confirm_with_yes_to_perform_this_action>
<check_resource_is_alive>
@REM terraform destroy
