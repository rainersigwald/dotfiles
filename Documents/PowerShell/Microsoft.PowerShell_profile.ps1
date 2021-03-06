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

. ~\scoop\apps\fd\current\_fd.ps1
