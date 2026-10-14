# dotfiles
Configuration for my user-profile needs.

## Windows
```powershell
winget install --id Git.Git -e --source winget
winget install --id twpayne.chezmoi -e --source winget
winget install --id Microsoft.PowerShell -e --source winget

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

If WinGet reports that extended features are disabled, enable its configuration
components once (requires Microsoft Store access):
```powershell
winget configure --enable
```

Open a new PowerShell 7 session so the installed commands are on PATH, then run:
```powershell
chezmoi init --apply rainersigwald
```

Applications are declared in `Windows\configuration.winget` and installed by
WinGet Configuration using the [v3 schema](https://learn.microsoft.com/en-us/windows/package-manager/configuration/create-v3)
(WinGet 1.11 or newer). WinGet automatically installs the
`Microsoft.DesiredStateConfiguration` package for the `dscv3` processor.
Configuration uses native `Microsoft.WinGet/Package` resources. The machine-wide
installers for 7-Zip, Azure CLI, GitHub CLI, Graphviz, gsudo, and Starship share an
elevated worker, requesting UAC approval once. Other resources remain in the
current-user context. PowerShell defaults to per-user MSIX; selecting its
machine-wide MSI instead would also require an elevated resource.
Existing applications are not forcibly upgraded.
DSC installs `posh-git` and `PSFzf` from PowerShell Gallery in CurrentUser scope
after PowerShell is available, skipping modules already installed.
The Azure DevOps CLI extension remains a separate follow-up step.

The chezmoi installer hashes the configuration, so configuration edits rerun
setup. Existing Scoop installations and their data are left intact.

## macOS
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install chezmoi

chezmoi init rainersigwald
chezmoi apply
```

## Ubuntu
```sh
sudo apt install zsh -y
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply rainersigwald
```
