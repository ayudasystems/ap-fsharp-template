@echo off

if [%1]==[] (set /p SOLUTION_NAME="Enter Solution name: ") else (set SOLUTION_NAME=%1)
if [%2]==[] (set /p PROJECT_NAME="Enter Project name: ") else (set PROJECT_NAME=%2)
if [%3]==[] (set /p OUTPUT_PATH="Enter Solution directory: ") else (set OUTPUT_PATH=%3)
set CURRENT_DIR=%cd%

dotnet new --install .
dotnet new sln -n %SOLUTION_NAME% -o %OUTPUT_PATH%\%SOLUTION_NAME%
dotnet new broadsign-fsharpapp -n %PROJECT_NAME% -o %OUTPUT_PATH%\%SOLUTION_NAME%
dotnet sln %OUTPUT_PATH%\%SOLUTION_NAME%\%SOLUTION_NAME%.sln add %OUTPUT_PATH%\%SOLUTION_NAME%\%PROJECT_NAME%\%PROJECT_NAME%.fsproj
dotnet build %OUTPUT_PATH%\%SOLUTION_NAME%\%SOLUTION_NAME%.sln
dotnet new -u %CURRENT_DIR%