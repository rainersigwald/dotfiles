# dotfiles
Configuration for my user-profile needs.

## Windows
```powershell
winget configure --enable
winget install --id Git.Git -e --source winget
winget install --id twpayne.chezmoi -e --source winget
winget install --id Microsoft.PowerShell -e --source winget
```

Open a new PowerShell 7 session so the installed commands are on PATH, then run:
```powershell
chezmoi init --apply rainersigwald
```

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
