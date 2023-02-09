#!/bin/bash

isValidOption() {
  array=("$@")
  value=${array[-1]}
  unset array[-1]

  for i in "${array[@]}"
  do
    if [[ "$i" == $value ]]; then
      return 0
    fi
  done
  return 1
}

parseLocation() {
  region=$1
  case $region in
    "na")
      echo "northcentralus";;

    "eu")
      echo "northeurope";;

    "ap")
      echo "australiaeast";;

    *)
      echo "unknown";;
  esac
}

AssignRoles() {
  AZ_ROOT_NAME=$1
  inputEnvironment=$2
  inputRegion=$3

  # Build all script variables from cloud principal account
  PRINCIPAL_ACCOUNT_PREFIX="PA-"
  PRINCIPAL_ACCOUNT_SUFFIX_LABS="-labs"
  PRINCIPAL_ACCOUNT_SUFFIX_PREVIEW="-preview"
  PRINCIPAL_ACCOUNT_SUFFIX_CLOUD="-cloud"
  RESOURCE_GROUP_NAME_PREFIX="rg-"

  echo "AZ_ROOT_NAME: $AZ_ROOT_NAME"

  [[ "$inputEnvironment" == "all" ]] && environments=("labs" "preview" "cloud") || environments=($inputEnvironment)
  [[ "$inputRegion" == "all" ]] && regions=("na" "eu" "ap") || regions=($inputRegion)
  
  for environment in "${environments[@]}";
    do
      if [ $environment == "cloud" ];
        then
            echo "Setting as Cloud"
            # Cloud config
            az account set --subscription "Ayuda Cloud"
            BROADSIGN_RG="rg-broadsign-cloud-eu-01"
            TF_STATE="tfstateeu"
            TF_STORAGE="tfstateeucloud"
            TF_UAI="Circleci-Terraform-ACR-pull-EU"
            SERVICE_PROVIDER="sp-broadsign-linux-cloud-eu-01"
            USER_RG="ayudacloud-eu-01"
      else
        # Labs and Preview config
        echo "Setting as preview"
        az account set --subscription "Ayuda Preview"
        if [ $environment == "labs" ];
          then
              BROADSIGN_RG="rg-broadsign-labs-na-01"
              TF_STATE="tfstatenaci"
              TF_STORAGE="tfstatenaci"
              TF_UAI="Circleci-Terraform-ACR-pull-EU-UAT"
              SERVICE_PROVIDER="sp-broadsign-linux-labs-na-01"
              USER_RG="ayudapreview-eu-01"
          else
              BROADSIGN_RG="rg-broadsign-preview-eu-01"
              TF_STATE="tfstateeuuat"
              TF_STORAGE="tfstateeuuat"
              TF_UAI="Circleci-Terraform-ACR-pull-EU-UAT"
              SERVICE_PROVIDER="sp-broadsign-linux-preview-eu-01"
              USER_RG="ayudapreview-eu-01"
        fi
    fi
    SUBSCRIPTION_ID=$(az account show --query id --output tsv)
    echo "Assigning roles for $environment."
    for region in "${regions[@]}";
      do
        if [ $environment == "labs" ] && ! [ $region == "na" ]; 
        then
          echo "$region region is not available on $environment continuing."
          continue
        fi
        location=$(parseLocation $region)
        # BROADSIGN_RG = "rg-broadsign-$environment-$region-01"
        RESOURCE_GROUP_NAME_SUFFIX="-$environment-$region"
        RESOURCE_GROUP="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX-01"
        PRINCIPAL_ACCOUNT="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX"
        PRINCIPAL_ACCOUNT_OBJ_ID=$(az ad sp list --display-name $PRINCIPAL_ACCOUNT --query [].id --output tsv)

        echo "LOCATION: $location"
        echo "TF_STATE: $TF_STATE"
        echo "TF_STORAGE: $TF_STORAGE"
        echo "SERVICE_PROVIDER: $SERVICE_PROVIDER"
        echo "USER_RG: $USER_RG"
        echo "RESOURCE GROUP: $RESOURCE_GROUP"
        echo "PRINCIPAL ACCOUNT: $PRINCIPAL_ACCOUNT"
        echo "PRINCIPAL ACCOUNT OBJ ID: $PRINCIPAL_ACCOUNT_OBJ_ID"

        # # Create cloud infra
        # # Engineers does not have permissions to create Resource Groups in Cloud
        if [ $environment == "cloud" ];
          then
          az group create -l $location -n $RESOURCE_GROUP
          echo "$RESOURCE_GROUP Created."
        fi

        # echo "RESULT_AZ_COMMAND= role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Contributor" --resource-group $RESOURCE_GROUP"
        az role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Contributor" --resource-group $RESOURCE_GROUP
        # echo "Contributor Role assignment command executed for $RESOURCE_GROUP."
        # echo "RESULT_AZ_COMMAND= role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\$TF_STATE\\providers\\Microsoft.Storage\\storageAccounts\\$TF_STORAGE"
        az role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\$TF_STATE\\providers\\Microsoft.Storage\\storageAccounts\\$TF_STORAGE
        # echo "Contributor Role assignment command executed for Terraform StorageAccount $TF_STORAGE."
        # echo "RESULT_AZ_COMMAND= role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Reader" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\$BROADSIGN_RG\\providers\\Microsoft.Web\\serverFarms\\$SERVICE_PROVIDER"
        az role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Reader" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\$BROADSIGN_RG\\providers\\Microsoft.Web\\serverFarms\\$SERVICE_PROVIDER
        # echo "Reader Role assignment command executed for App Service Plan $SERVICE_PROVIDER"
        # echo "RESULT_AZ_COMMAND= role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourcegroups\\$USER_RG\\providers\\Microsoft.ManagedIdentity\\userAssignedIdentities\\$TF_UAI"
        az role assignment create --assignee $PRINCIPAL_ACCOUNT_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourcegroups\\$USER_RG\\providers\\Microsoft.ManagedIdentity\\userAssignedIdentities\\$TF_UAI
        # echo "Contributor Role assignment command executed for UAI $TF_UAI"
      done;
    echo "Roles assignment process for $environment finished."
  done;
}

# Prepare variables and tmp directory
if [[ "$1" == "" ]];
then
  echo "Enter Principal Account Root Name. E.g. PA-fsharptemplate-cloud-eu -> fsharptemplate:"
  read PA_ACCOUNT
else
  PA_ACCOUNT=$1
fi

while [ -z $AZ_ENVIRONMENT_NAME ]
do
  validOptions=("labs" "preview" "cloud" "all")
  echo "Environment: (<labs>,<preview>,<cloud>,<all>). E.g."
  read AZ_ENVIRONMENT_NAME

  if ! isValidOption "${validOptions[@]}" $AZ_ENVIRONMENT_NAME; then
    echo "Error, invalid option entered, try again"
    unset AZ_ENVIRONMENT_NAME
  fi
done

while [ -z $AZ_REGION ]
do
  validOptions=("na" "eu" "ap" "all")
  echo "Region: (<na>,<eu>,<ap>,<all>)"
  read AZ_REGION

  if ! isValidOption "${validOptions[@]}" $AZ_REGION; then
    echo "Error, invalid option entered, try again"
    unset AZ_REGION
  fi
done

# Login with your admin account
az login 

AssignRoles $PA_ACCOUNT $AZ_ENVIRONMENT_NAME $AZ_REGION

# Labs and Preview config
# az account set --subscription "Ayuda Preview" > /dev/null 2>&1
# SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Config variables
# RESOURCE_GROUP_NAME_PREFIX="rg-"
# RESOURCE_GROUP_NAME_SUFFIX_LABS="-labs-na-01"
# RESOURCE_GROUP_NAME_SUFFIX_PREVIEW="-preview-eu-01"

# Assign roles labs principal
# RESOURCE_GROUP_LABS="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_LABS"
# PRINCIPAL_ACCOUNT_LABS="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_LABS"
# PRINCIPAL_ACCOUNT_LABS_OBJ_ID=$(az ad sp list --display-name $PRINCIPAL_ACCOUNT_LABS --query [].id --output tsv)

# echo "RESOURCE_GROUP_LABS: $RESOURCE_GROUP_LABS"
# echo "PRINCIPAL_ACCOUNT_LABS: $PRINCIPAL_ACCOUNT_LABS"
# echo "PRINCIPAL_ACCOUNT_LABS_OBJ_ID: $PRINCIPAL_ACCOUNT_LABS_OBJ_ID"

# if [[ "$ADMIN_ENVIRONMENT_NAME" == "labs" || "$ADMIN_ENVIRONMENT_NAME" == "all" ]];
# then
# echo "Assigning roles for Labs."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_LABS_OBJ_ID --role "Contributor" --resource-group $RESOURCE_GROUP_LABS)
# echo "Contributor Role assignment command executed for RG $RESOURCE_GROUP_LABS."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_LABS_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\tfstatenaci\\providers\\Microsoft.Storage\\storageAccounts\\tfstatenaci)
# echo "Contributor Role assignment command executed for Terraform StorageAccount tfstatenaci."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_LABS_OBJ_ID --role "Reader" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\rg-broadsign-labs-na-01\\providers\\Microsoft.Web\\serverFarms\\sp-broadsign-linux-labs-na-01)
# echo "Reader Role assignment command executed for App Service Plan sp-broadsign-linux-labs-na-01."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_LABS_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourcegroups\\ayudapreview-eu-01\\providers\\Microsoft.ManagedIdentity\\userAssignedIdentities\\Circleci-Terraform-ACR-pull-EU-UAT)
# echo "Contributor Role assignment command executed for UAI Circleci-Terraform-ACR-pull-EU-UAT."
# echo "Roles assignment process for Labs finished."
# fi
# # Assign roles preview principal
# RESOURCE_GROUP_PREVIEW="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_PREVIEW"
# PRINCIPAL_ACCOUNT_PREVIEW="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_PREVIEW"
# PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID=$(az ad sp list --display-name $PRINCIPAL_ACCOUNT_PREVIEW --query [].id --output tsv)

# if [[ "$ADMIN_ENVIRONMENT_NAME" == "preview" || "$ADMIN_ENVIRONMENT_NAME" == "all" ]];
# then
# echo "Assigning roles for Preview."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID --role "Contributor" --resource-group $RESOURCE_GROUP_PREVIEW)
# echo "Contributor Role assignment command executed for RG $RESOURCE_GROUP_PREVIEW."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\tfstateeuuat\\providers\\Microsoft.Storage\\storageAccounts\\tfstateeuuat)
# echo "Contributor Role assignment command executed for Terraform StorageAccount tfstateeuuat."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID --role "Reader" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\rg-broadsign-preview-eu-01\\providers\\Microsoft.Web\\serverFarms\\sp-broadsign-linux-preview-eu-01)
# echo "Reader Role assignment command executed for App Service Plan sp-broadsign-linux-preview-eu-01."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_PREVIEW_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourcegroups\\ayudapreview-eu-01\\providers\\Microsoft.ManagedIdentity\\userAssignedIdentities\\Circleci-Terraform-ACR-pull-EU-UAT)
# echo "Contributor Role assignment command executed for UAI Circleci-Terraform-ACR-pull-EU-UAT."
# echo "Roles assignment process for Preview finished."
# fi

# # Cloud config
# az account set --subscription "Ayuda Cloud"  > /dev/null 2>&1
# SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# # Config variables
# RESOURCE_GROUP_NAME_SUFFIX_CLOUD="-cloud-eu-01"
# RESOURCE_GROUP_NAME_LOCATION_CLOUD="northeurope"

# # Assign roles cloud principal
# RESOURCE_GROUP_CLOUD="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_CLOUD"
# PRINCIPAL_ACCOUNT_CLOUD="$PA_ACCOUNT_CLOUD"
# PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID=$(az ad sp list --display-name $PRINCIPAL_ACCOUNT_CLOUD --query [].id --output tsv)

# # Create cloud infra
# # Engineers does not have permissions to create Resource Groups in Cloud
# if [[ "$ADMIN_ENVIRONMENT_NAME" == "cloud" || "$ADMIN_ENVIRONMENT_NAME" == "all" ]];
# then
# az group create -l $RESOURCE_GROUP_NAME_LOCATION_CLOUD -n $RESOURCE_GROUP_CLOUD > /dev/null 2>&1
# echo "$RESOURCE_GROUP_CLOUD Created."

# echo "Assigning roles for Cloud."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID --role "Contributor" --resource-group $RESOURCE_GROUP_CLOUD)
# echo "Contributor Role assignment command executed for RG $RESOURCE_GROUP_CLOUD."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\tfstateeu\\providers\\Microsoft.Storage\\storageAccounts\\tfstateeucloud)
# echo "Contributor Role assignment command executed for Terraform StorageAccount tfstateeucloud."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID --role "Reader" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourceGroups\\rg-broadsign-cloud-eu-01\\providers\\Microsoft.Web\\serverFarms\\sp-broadsign-linux-cloud-eu-01)
# echo "Reader Role assignment command executed for App Service Plan sp-broadsign-linux-cloud-eu-01."
# RESULT_AZ_COMMAND=$(az role assignment create --assignee $PRINCIPAL_ACCOUNT_CLOUD_OBJ_ID --role "Contributor" --scope \\subscriptions\\$SUBSCRIPTION_ID\\resourcegroups\\ayudacloud-eu-01\\providers\\Microsoft.ManagedIdentity\\userAssignedIdentities\\Circleci-Terraform-ACR-pull-EU)
# echo "Contributor Role assignment command executed for UAI Circleci-Terraform-ACR-pull-EU."
# echo "Roles assignment process for Cloud finished."
# fi