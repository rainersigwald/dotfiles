param (
    [parameter(Position=0)]
    [String]
    $nameOrUrl
)

$ErrorActionPreference = "Stop"

$reproRoot = $env:LOCAL_REPRO_FOLDER
if ([string]::IsNullOrEmpty($reproRoot)) {
    $reproRoot = "s:\repro"
}

if ($nameOrUrl.StartsWith("https://github.com/")) {
    $relativeFolder = $nameOrUrl.Substring("https://github.com/".Length)
}

if (($nameOrUrl -match '^https://(?<org>\w+)\.visualstudio\.com/(?:DefaultCollection/)?(?<project>[^/]+)/_workitems/(?:edit/)?(?<number>\d+)(?:\?.*)?') -or
    ($nameOrUrl -match '^https://dev\.azure\.com/(?<org>[^/]+)/(?<project>[^/]+)/_workitems/(?:edit/)?(?<number>\d+)(?:\?.*)?')) {
    $relativeFolder = [IO.Path]::Combine( $Matches.org, $Matches.project, $Matches.number )
}

Write-Host $relativeFolder

$fullPath = Join-Path -path $reproRoot -ChildPath $relativeFolder

Write-Host $fullPath

if (Test-Path -PathType Container -Path $fullPath) {
    Write-Error "Folder $fullPath already exists"
}

New-Item -ItemType Directory -Path $fullPath

Push-Location -Path $fullPath

git.exe init .

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore" -OutFile ".gitignore"

git.exe add (Join-Path $fullPath ".gitignore")

git.exe commit --message="Initializing repro for $nameOrUrl"

Write-Host "Repro folder created at $fullPath"

&"$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" $fullPath