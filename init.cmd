@echo off

if [%1]==[] (set /p SOLUTION_NAME="Enter Solution name: ") else (set SOLUTION_NAME=%1)
if [%2]==[] (set /p PROJECT_NAME="Enter Project name: ") else (set PROJECT_NAME=%2)
set CURRENT_DIR=%cd%
set TMP_DIR=C:\tmp\
IF not exist %TMP_DIR% (mkdir %TMP_DIR%)

dotnet new --install .
dotnet new sln -n %SOLUTION_NAME% -o %TMP_DIR%\%SOLUTION_NAME%
dotnet new broadsign-fsharpapp -n %PROJECT_NAME% -o %TMP_DIR%\%SOLUTION_NAME%
dotnet sln %TMP_DIR%\%SOLUTION_NAME%\%SOLUTION_NAME%.sln add %TMP_DIR%\%SOLUTION_NAME%\%PROJECT_NAME%\%PROJECT_NAME%.fsproj
dotnet build %TMP_DIR%\%SOLUTION_NAME%\%SOLUTION_NAME%.sln
dotnet new -u %CURRENT_DIR%