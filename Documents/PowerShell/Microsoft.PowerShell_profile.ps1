Invoke-Expression (&starship init powershell)

Import-Module posh-git

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
           [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine

    Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
}

function FdWithMyArguments {
    fd.exe --type file --hidden --no-ignore-vcs $args
}

Set-Alias -Name fd -Value FdWithMyArguments

. ~\scoop\apps\fd\current\autocomplete\fd.ps1

function TaskWarriorInWsl {
    wsl task $args
}

Set-Alias -Name task -Value TaskWarriorInWsl

function IsBuildyProcess {
    param([System.Diagnostics.Process] $process)

    $processName = $process.Name

    if ($processName -match "(MSBuild|VBCSCompiler|vsjitdebugger)") {
        return $true
    }

    # is it a dotnet msbuild or vbcscompiler process, or a test runner?
    if ($processName -eq "dotnet") {
        $commandLine = $process.CommandLine
        if ($commandLine -match "MSBuild|VBCSCompiler|xunit") {
            return $true
        }
    }
}

function Stop-BuildyProcesses {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if ($PSCmdlet.ShouldProcess($(Get-Command "dotnet"), "build-server shutdown")) {
        dotnet.exe build-server shutdown
    }

    $processes = Get-Process | Where-Object { IsBuildyProcess $_ }

    if ($null -ne $processes) {
        Stop-Process -InputObject $processes -Force -Verbose -WhatIf:$WhatIfPreference
    }
}

Set-Alias -name kill -value Stop-BuildyProcesses

function New-Repro {
    [CmdletBinding()]
    param (
        [parameter(Position = 0)]
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

    dotnet new gitignore

    git.exe add (Join-Path $fullPath ".gitignore")

    git.exe commit --message="Initializing repro for $nameOrUrl"

    Write-Host "Repro folder created at $fullPath"

    &"$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" $fullPath
}

Set-Alias -name repro -value New-Repro

function ToggleMSBuildDebug {
    if ($env:MSBUILDDEBUGONSTART -eq 1) {
        $env:MSBUILDDEBUGONSTART = $null
    }
    else {
        $env:MSBUILDDEBUGONSTART = 1
    }
}

Set-Alias -name msbd -Value ToggleMSBuildDebug

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell) -join "`n"
})

## Experimental Atuin stuff

try {
    Get-Command atuin -ErrorAction Stop

    # Atuin must exist so register history via https://github.com/atuinsh/atuin/issues/84#issuecomment-2053600939

    $env:ATUIN_SESSION = (atuin uuid | Out-String).Trim()
    $env:ATUIN_HISTORY_ID = $null

    Set-PSReadLineKeyHandler -Chord Enter -ScriptBlock {
        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if (-not $env:ATUIN_HISTORY_ID) {
            $env:ATUIN_HISTORY_ID = (atuin history start -- $line | Out-String).Trim()
        }

        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }

    $existingPromptFunction = Get-Item -Path Function:\prompt
    Remove-Item -Path Function:\prompt
    function prompt {
        if ($env:ATUIN_HISTORY_ID) {
            atuin history end --duration (Get-History -Count 1).Duration.TotalNanoseconds --exit $LASTEXITCODE -- $env:ATUIN_HISTORY_ID | Out-Null

            Remove-Item -Path env:ATUIN_HISTORY_ID -ErrorAction SilentlyContinue
        }

        & $existingPromptFunction.ScriptBlock
    }
}
catch {
    # Atuin is not installed; do nothing
}