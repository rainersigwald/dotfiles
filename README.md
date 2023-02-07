# dotfiles
Configuration for my user-profile needs.

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

scoop install chezmoi

chezmoi init rainersigwald
chezmoi apply
```
