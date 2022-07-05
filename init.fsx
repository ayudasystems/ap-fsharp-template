open System
open System.IO

let replaceTextsInFile (file: string) (oldText: string) (newText: string)=
    let text = File.ReadAllText(file)
    let newText = text.Replace(oldText, newText)
    File.WriteAllText(file, newText)
    
let templateName = "FSharpTemplate"
printf "Enter new Project name: "
let newProjectName = Console.ReadLine()

Directory.Move(templateName, newProjectName)

let rootDirectory = Directory.GetCurrentDirectory()
//CircleCI
let circleCiConfigFile =  $"%s{rootDirectory}\.circleci\config.yml"
replaceTextsInFile circleCiConfigFile templateName newProjectName
replaceTextsInFile circleCiConfigFile (templateName.ToLower()) (newProjectName.ToLower())

//Docker
let dockerFile = $"%s{rootDirectory}\DockerFile"
replaceTextsInFile dockerFile templateName newProjectName

//Project codes
let templateProjectFile = $"%s{rootDirectory}\%s{newProjectName}\%s{templateName}.fsproj"
let newProjectFile = $"%s{rootDirectory}\%s{newProjectName}\%s{newProjectName}.fsproj"
File.Move(templateProjectFile, newProjectFile)
let codeFiles = Directory.EnumerateFiles($"%s{rootDirectory}\%s{newProjectName}", "*.fs")
for codeFile in codeFiles do
    replaceTextsInFile codeFile templateName newProjectName
