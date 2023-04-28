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

    if ($processName -match "(MSBuild|VBCSCompiler)") {
        return $true
    }

    # is it a dotnet msbuild or vbcscompiler process?
    if ($processName -eq "dotnet") {
        $commandLine = $process.CommandLine
        if ($commandLine -match "MSBuild|VBCSCompiler") {
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
