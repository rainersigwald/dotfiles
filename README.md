# dotfiles
Configuration for my user-profile needs.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

scoop install chezmoi

chezmoi init rainersigwald
chezmoi apply
```

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install chezmoi

chezmoi init rainersigwald
chezmoi apply
```
