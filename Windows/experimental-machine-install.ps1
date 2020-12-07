# Install Scoop itself

Set-ExecutionPolicy RemoteSigned -scope CurrentUser

Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')

if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue))
{
   Write-Error "Install git manually before running this script: https://git-scm.com/download/win"
}

setx FZF_DEFAULT_COMMAND "fd --type file --hidden --no-ignore --no-ignore-vcs"

# az devops configure --defaults organization=https://dev.azure.com/devdiv
# az devops configure --defaults project=DevDiv
