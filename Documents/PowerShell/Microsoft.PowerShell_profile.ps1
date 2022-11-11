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
