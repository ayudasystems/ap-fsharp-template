@echo off

rem Prepare variables and tmp directory
if [%1]==[] (set /p SOLUTION_NAME="Enter Solution name: ") else (set SOLUTION_NAME=%1)
if [%2]==[] (set /p PROJECT_NAME="Enter Project name: ") else (set PROJECT_NAME=%2)
if [%3]==[] (set /p CIRCLECI_STRATEGY="Enter CI/CD Strategy: (<Automatic>,<Approval>) ") else (set CIRCLECI_STRATEGY=%3)
set CURRENT_DIR=%cd%
set TMP_DIR=C:\tmp\
IF not exist %TMP_DIR% (mkdir %TMP_DIR%)

rem Apply ci/cd pipeline strategy
del .circleci\config.yml
if %CIRCLECI_STRATEGY%==Approval (
    ren .circleci\config-approval.yml config.yml
    del .circleci\config-automatic.yml
)
else (
    ren .circleci\config-automatic.yml config.yml
    del .circleci\config-approval.yml
)

rem Apply template
dotnet new --install .
dotnet new sln -n %SOLUTION_NAME% -o %TMP_DIR%\%SOLUTION_NAME% --force
dotnet new broadsign-fsharpapp -n %PROJECT_NAME% -o %TMP_DIR%\%SOLUTION_NAME%
dotnet sln %TMP_DIR%\%SOLUTION_NAME%\%SOLUTION_NAME%.sln add %TMP_DIR%\%SOLUTION_NAME%\%PROJECT_NAME%\%PROJECT_NAME%.fsproj
dotnet build %TMP_DIR%\%SOLUTION_NAME%\%SOLUTION_NAME%.sln
dotnet new -u "%CURRENT_DIR%"

rem Copy created solution
for /d %%d in (*) do rmdir /s /q %%d
for %%f in (*) do if not %%f == init.cmd del /q %%f
xcopy %TMP_DIR%\%SOLUTION_NAME% "%CURRENT_DIR%" /e /y /c /q /r
rmdir /s /q %TMP_DIR%\%SOLUTION_NAME%
del /q init.cmd