#!/bin/bash
# Prepare variables and tmp directory
if [[ "$1" == "" ]];
then 
  echo "Enter Solution name: "
  read SOLUTION_NAME
else 
  SOLUTION_NAME=$1
fi
if [[ "$2" == "" ]];
then 
  echo "Enter Project name: "
  read PROJECT_NAME
else 
  PROJECT_NAME=$2
fi
if [[ "$3" == "" ]];
then
  echo "Enter CI/CD Strategy: (<Automatic>,<Approval>) "
  read CIRCLECI_STRATEGY
else
  CIRCLECI_STRATEGY=$3
fi
CURRENT_DIR=$PWD
TMP_DIR=/tmp/

# Apply ci/cd pipeline strategy
rm -f .circleci/config.yml
if [[ $CIRCLECI_STRATEGY -eq "Approval"]];
    mv ".circleci/config-approval.yml" "circle.yml"
    rm -f .circleci/config-automatic.yml
else
    mv ".circleci/config-automatic.yml" "circle.yml"
    rm -f .circleci/config-approval.yml
fi

# Apply template
dotnet new --install .
dotnet new sln -n $SOLUTION_NAME -o "$TMP_DIR/$SOLUTION_NAME" --force
dotnet new broadsign-fsharpapp -n $PROJECT_NAME -o $TMP_DIR/$SOLUTION_NAME
dotnet sln $TMP_DIR/$SOLUTION_NAME/$SOLUTION_NAME.sln add $TMP_DIR/$SOLUTION_NAME/$PROJECT_NAME/$PROJECT_NAME.fsproj
dotnet build $TMP_DIR/$SOLUTION_NAME/$SOLUTION_NAME.sln
dotnet new -u "$CURRENT_DIR"

# Copy created solution
shopt -s extglob 
rm -vrf !(init.sh)
find . -type d -name '.[^.]*' -not -path './.git' -prune -exec rm -rf {} +
cp -rf $TMP_DIR/$SOLUTION_NAME/* "$CURRENT_DIR" 
rm -rf $TMP_DIR/$SOLUTION_NAME
rm -f init.sh