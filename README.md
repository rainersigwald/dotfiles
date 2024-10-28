# dotfiles
Configuration for my user-profile needs.

Windows:

```powershell
winget install --id Git.Git -e --source winget

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

scoop install chezmoi

chezmoi init --apply rainersigwald
```

macOS:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install chezmoi

chezmoi init rainersigwald
chezmoi apply
```
