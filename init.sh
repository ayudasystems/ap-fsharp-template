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
CURRENT_DIR=$PWD
TMP_DIR=/tmp/

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