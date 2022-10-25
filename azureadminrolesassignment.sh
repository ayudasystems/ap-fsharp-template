#!/bin/bash
# Prepare variables and tmp directory
if [[ "$1" == "" ]];
then
  echo "Enter Principal Account Cloud. E.g. PA-fsharptemplate-cloud: "
  read PA_ACCOUNT_CLOUD
else
  PA_ACCOUNT_CLOUD=$1
fi

# Build all script variables from cloud principal account
PRINCIPAL_ACCOUNT_PREFIX="PA-"
PRINCIPAL_ACCOUNT_SUFFIX_LABS="-labs"
PRINCIPAL_ACCOUNT_SUFFIX_PREVIEW="-preview"
PRINCIPAL_ACCOUNT_SUFFIX_CLOUD="-cloud"
AZ_ROOT_NAME_TMP=${PA_ACCOUNT_CLOUD#$PRINCIPAL_ACCOUNT_PREFIX}
AZ_ROOT_NAME=${AZ_ROOT_NAME_TMP%$PRINCIPAL_ACCOUNT_SUFFIX_CLOUD}

# Login with your admin account
az login > /dev/null 2>&1

# Labs and Preview config
az account set --subscription "Ayuda Preview" > /dev/null 2>&1
SUBSCRIPTION_ID=`az account show --query id --output tsv`

# Config variables
RESOURCE_GROUP_NAME_PREFIX="rg-"
RESOURCE_GROUP_NAME_SUFFIX_LABS="-labs-na-01"
RESOURCE_GROUP_NAME_SUFFIX_PREVIEW="-preview-eu-01"

# Assign roles labs principal
RESOURCE_GROUP_LABS="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_LABS"
PRINCIPAL_ACCOUNT_LABS="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_LABS"
PRINCIPAL_ACCOUNT_LABS_OBJ_ID=`az ad sp list --display-name "$PRINCIPAL_ACCOUNT_LABS" --query [].objectId --output tsv`

echo "Assigning roles for Labs."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_LABS_OBJ_ID" --role "Contributor" --resource-group "$RESOURCE_GROUP_LABS" > /dev/null 2>&1
echo "Contributor Role assigned to RG $RESOURCE_GROUP_LABS."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_LABS_OBJ_ID" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/tfstatenaci/providers/Microsoft.Storage/storageAccounts/tfstatenaci" > /dev/null 2>&1
echo "Contributor Role assigned to Terraform StorageAccount tfstatenaci."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_LABS_OBJ_ID" --role "Reader" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-broadsign-labs-na-01/providers/Microsoft.Web/serverFarms/sp-broadsign-linux-labs-na-01" > /dev/null 2>&1
echo "Reader Role assigned to App Service Plan sp-broadsign-linux-labs-na-01."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_LABS_OBJ_ID" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourcegroups/ayudapreview-eu-01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/Circleci-Terraform-ACR-pull-EU-UAT" > /dev/null 2>&1
echo "Contributor Role assigned to UAI Circleci-Terraform-ACR-pull-EU-UAT."
echo "Roles for Labs assigned."

# Assign roles preview principal
RESOURCE_GROUP_PREVIEW="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_PREVIEW"
PRINCIPAL_ACCOUNT_PREVIEW="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_PREVIEW"
PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID=`az ad sp list --display-name "$PRINCIPAL_ACCOUNT_PREVIEW" --query [].objectId --output tsv`

echo "Assigning roles for Preview."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID" --role "Contributor" --resource-group "$RESOURCE_GROUP_PREVIEW" > /dev/null 2>&1
echo "Contributor Role assigned to RG $RESOURCE_GROUP_PREVIEW."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/tfstateeuuat/providers/Microsoft.Storage/storageAccounts/tfstateeuuat" > /dev/null 2>&1
echo "Contributor Role assigned to Terraform StorageAccount tfstateeuuat."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID" --role "Reader" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-broadsign-preview-eu-01/providers/Microsoft.Web/serverfarms/sp-broadsign-linux-preview-eu-01" > /dev/null 2>&1
echo "Reader Role assigned to App Service Plan sp-broadsign-linux-preview-eu-01."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourcegroups/ayudapreview-eu-01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/Circleci-Terraform-ACR-pull-EU-UAT" > /dev/null 2>&1
echo "Contributor Role assigned to UAI Circleci-Terraform-ACR-pull-EU-UAT."
echo "Roles for Preview assigned."

# Cloud config
az account set --subscription "Ayuda Cloud"  > /dev/null 2>&1
SUBSCRIPTION_ID=`az account show --query id --output tsv`

# Config variables
RESOURCE_GROUP_NAME_SUFFIX_CLOUD="-cloud-eu-01"
RESOURCE_GROUP_NAME_LOCATION_CLOUD="northeurope"

# Assign roles cloud principal
RESOURCE_GROUP_CLOUD="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_CLOUD"
PRINCIPAL_ACCOUNT_CLOUD="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_CLOUD"
PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID=`az ad sp list --display-name "$PRINCIPAL_ACCOUNT_CLOUD" --query [].objectId --output tsv`

## Create cloud infra
# Engineers does not have permissions to create Resource Groups in Cloud
az group create -l "$RESOURCE_GROUP_NAME_LOCATION_CLOUD" -n "$RESOURCE_GROUP_CLOUD" > /dev/null 2>&1
echo "$RESOURCE_GROUP_CLOUD Created."

echo "Assigning roles for Cloud."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID" --role "Contributor" --resource-group "$RESOURCE_GROUP_CLOUD"
echo "Contributor Role assigned to RG $RESOURCE_GROUP_CLOUD."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/tfstateeu/providers/Microsoft.Storage/storageAccounts/tfstateeucloud"
echo "Contributor Role assigned to Terraform StorageAccount tfstateeucloud."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID" --role "Reader" --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-broadsign-cloud-eu-01/providers/Microsoft.Web/serverfarms/sp-broadsign-linux-cloud-eu-01"
echo "Reader Role assigned to App Service Plan sp-broadsign-linux-cloud-eu-01."
az role assignment create --assignee "$PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID" --role "Contributor" --scope "/subscriptions/$SUBSCRIPTION_ID/resourcegroups/ayudacloud-eu-01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/Circleci-Terraform-ACR-pull-EU"
echo "Contributor Role assigned to UAI Circleci-Terraform-ACR-pull-EU."
echo "Roles for Cloud assigned."
