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

createInfrastructure() {
  inputServiceName=$1
  inputEnvironment=$2
  inputRegion=$3

  # Config variables
  RESOURCE_GROUP_NAME_PREFIX="rg"
  PRINCIPAL_ACCOUNT_PREFIX="PA"

  [[ "$inputEnvironment" == "all" ]] && environments=("labs" "preview" "cloud") || environments=($inputEnvironment)
  [[ "$inputRegion" == "all" ]] && regions=("na" "eu" "ap") || regions=($inputRegion)
  
  for environment in "${environments[@]}";
    do
    
    if [ $environment == "cloud" ];
      then
          # Cloud config
          az account set --subscription "Ayuda Cloud"
      else
        # Labs and Preview config
        az account set --subscription "Ayuda Preview"
    fi

      for region in "${regions[@]}";
        do
          location=$(parseLocation $region)
          RESOURCE_GROUP="$RESOURCE_GROUP_NAME_PREFIX-$inputServiceName-$environment-$region-01"
          # az group create -l $location -n "$RESOURCE_GROUP"
          echo "$RESOURCE_GROUP Created." 
          PA_ACCOUNT="$PRINCIPAL_ACCOUNT_PREFIX-$inputServiceName-$environment-$region"
          # az ad sp create-for-rbac --name "$PA_ACCOUNT"
          echo "$PA_ACCOUNT Created."
        done;
    done;
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
  echo "Region: (<na>,<eu>,<ap>,<all>). E.g. as-$AZ_ROOT_NAME-$AZ_ENVIRONMENT_NAME-eu"
  read AZ_REGION

  if ! isValidOption "${validOptions[@]}" $AZ_REGION; then
    echo "Error, invalid option entered, try again"
    unset AZ_REGION
  fi
done

echo "Summary - Creating Resources for as-$AZ_ROOT_NAME-$AZ_ENVIRONMENT_NAME-$AZ_REGION"

# Login with your personal account
az login

createInfrastructure $AZ_ROOT_NAME $AZ_ENVIRONMENT_NAME $AZ_REGION

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
