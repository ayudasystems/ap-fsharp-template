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

# Prepare variables and tmp directory

if [[ "$1" == "" ]];
then
  echo "Enter Service Root Name (Lowercase). E.g. fsharptemplate -> as-fsharptemplate"
  read AZ_ROOT_NAME
else
  AZ_ROOT_NAME=$1
fi

while [ -z $AZ_ENVIRONMENT_NAME ]
do
  validOptions=("labs" "preview" "cloud" "all")
  echo "Environment: (<labs>,<preview>,<cloud>,<all>). E.g. as-$AZ_ROOT_NAME-cloud"
  read AZ_ENVIRONMENT_NAME

  if ! isValidOption "${validOptions[@]}" $AZ_ENVIRONMENT_NAME; then
    echo "Error, invalid option entered, try again"
    unset AZ_ENVIRONMENT_NAME
  fi
done

while [ -z $AZ_REGION ]
do
  validOptions=("na" "eu" "ap" "all")
  echo "Environment: (<na>,<eu>,<ap>,<all>). E.g. as-$AZ_ROOT_NAME-$AZ_ENVIRONMENT_NAME-eu"
  read AZ_REGION

  if ! isValidOption "${validOptions[@]}" $AZ_REGION; then
    echo "Error, invalid option entered, try again"
    unset AZ_REGION
  fi
done

echo "Summary - Creating Resources for as-$AZ_ROOT_NAME-$AZ_ENVIRONMENT_NAME-$AZ_REGION"


# # Login with your personal account
# az login

# # Labs and Preview config
# az account set --subscription "Ayuda Preview"

# # Config variables
# RESOURCE_GROUP_NAME_PREFIX="rg-"
# RESOURCE_GROUP_NAME_SUFFIX_LABS="-labs-na-01"
# RESOURCE_GROUP_NAME_LOCATION_LABS="northcentralus"
# RESOURCE_GROUP_NAME_SUFFIX_PREVIEW="-preview-eu-01"
# RESOURCE_GROUP_NAME_LOCATION_PREVIEW="northeurope"
# PRINCIPAL_ACCOUNT_PREFIX="PA-"
# PRINCIPAL_ACCOUNT_SUFFIX_LABS="-labs"
# PRINCIPAL_ACCOUNT_SUFFIX_PREVIEW="-preview"
# PRINCIPAL_ACCOUNT_SUFFIX_CLOUD="-cloud"

# # Create labs infra
# RESOURCE_GROUP_LABS="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_LABS"
# az group create -l "$RESOURCE_GROUP_NAME_LOCATION_LABS" -n "$RESOURCE_GROUP_LABS" > /dev/null 2>&1
# echo "$RESOURCE_GROUP_LABS Created."

# PA_ACCOUNT_LABS="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_LABS"
# az ad sp create-for-rbac --name "$PA_ACCOUNT_LABS"
# echo "$PA_ACCOUNT_LABS Created."

# # Create preview infra
# RESOURCE_GROUP_PREVIEW="$RESOURCE_GROUP_NAME_PREFIX$AZ_ROOT_NAME$RESOURCE_GROUP_NAME_SUFFIX_PREVIEW"
# az group create -l "$RESOURCE_GROUP_NAME_LOCATION_PREVIEW" -n "$RESOURCE_GROUP_PREVIEW" > /dev/null 2>&1
# echo "$RESOURCE_GROUP_PREVIEW Created."

# PA_ACCOUNT_PREVIEW="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_PREVIEW"
# az ad sp create-for-rbac --name "$PA_ACCOUNT_PREVIEW"
# echo "$PA_ACCOUNT_PREVIEW Created."

# # Cloud config
# az account set --subscription "Ayuda Cloud"  > /dev/null 2>&1

# ## Create cloud infra
# # Engineers does not have permissions to create Resource Groups in Cloud

# PA_ACCOUNT_CLOUD="$PRINCIPAL_ACCOUNT_PREFIX$AZ_ROOT_NAME$PRINCIPAL_ACCOUNT_SUFFIX_CLOUD"
# az ad sp create-for-rbac --name "$PA_ACCOUNT_CLOUD"
# echo "$PA_ACCOUNT_CLOUD Created."

# echo "################################"
# echo "Summary to report to Azure Admin"
# echo "Labs:"
# echo "Resource Group: $RESOURCE_GROUP_LABS"
# echo "Principal Account: $PA_ACCOUNT_LABS"
# echo "Preview:"
# echo "Resource Group: $RESOURCE_GROUP_PREVIEW"
# echo "Principal Account: $PA_ACCOUNT_PREVIEW"
# echo "Cloud:"
# echo "Resource Group: $RESOURCE_GROUP_CLOUD"
# echo "Principal Account: $PA_ACCOUNT_CLOUD"
# echo "################################"
