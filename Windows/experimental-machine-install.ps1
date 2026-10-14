$ErrorActionPreference = 'Stop'

Set-ExecutionPolicy RemoteSigned -scope CurrentUser

foreach ($id in 'Git.Git', 'twpayne.chezmoi', 'Microsoft.PowerShell') {
    winget.exe install --id $id --exact --source winget --no-upgrade --accept-package-agreements --accept-source-agreements
    # WinGet reports an already-installed package as a nonzero no-op.
    if ($LASTEXITCODE -notin 0, -1978335189, -1978335135) {
        throw "WinGet installation of $id failed with exit code $LASTEXITCODE"
    }
}

setx FZF_DEFAULT_COMMAND "fd --type file --hidden --no-ignore --no-ignore-vcs"

# az devops configure --defaults organization=https://dev.azure.com/devdiv
# az devops configure --defaults project=DevDiv
