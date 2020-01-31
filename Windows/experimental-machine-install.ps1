# Install Scoop itself

Set-ExecutionPolicy RemoteSigned -scope CurrentUser

Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')

if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue))
{
   Write-Error "Install git manually before running this script: https://git-scm.com/download/win"
}

scoop bucket add extras

# oreutils
scoop install ripgrep
scoop install fd

scoop install fzf
setx FZF_DEFAULT_COMMAND "fd --type file --hidden --no-ignore --no-ignore-vcs"

scoop install bat
New-Item -path $(Split-Path $(bat --config-file)) -ItemType Directory
New-Item -Path $(bat --config-file) -Value "--map-syntax proj:xml`n--map-syntax targets:xml`n--map-syntax props:xml"

# other utils
scoop install less # bat wants it, useful in general

scoop install starship

scoop install hub

# .NET development
scoop install ilspy

# Azure CLI
scoop install azure-cli

az extension add --name azure-devops

# az devops configure --defaults organization=https://dev.azure.com/devdiv
# az devops configure --defaults project=DevDiv

# Git

git config --global user.name "Rainer Sigwald"
git config --global user.email "raines@microsoft.com"

# # Note: diff-so-fancy locked to 1.2.0
# Invoke-WebRequest -Uri https://raw.githubusercontent.com/so-fancy/diff-so-fancy/v1.2.0/diff-so-fancy -OutFile $env:USERPROFILE\scoop\shims\diff-so-fancy
# New-Item -ItemType Directory $env:USERPROFILE\scoop\shims\lib
# Invoke-WebRequest -Uri https://raw.githubusercontent.com/so-fancy/diff-so-fancy/v1.2.0/lib/DiffHighlight.pm -OutFile $env:USERPROFILE\scoop\shims\lib\DiffHighlight.pm
# git config --global --add core.pager "'C:\\Program Files\\Git\\usr\\bin\\perl.exe' -I '$env:USERPROFILE\\scoop\\shims\\lib' '$env:USERPROFILE\\scoop\\shims\\diff-so-fancy'"

git config --global alias.lg "log --color --graph --date=human --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.publish "!git push --set-upstream origin `$(git rev-parse --abbrev-ref HEAD)"
git config --global alias.newbranch "!git checkout --no-track -b `$1 Microsoft/master  && :"
