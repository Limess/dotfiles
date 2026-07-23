# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Usage

To install to a new machine:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
$HOME/.local/bin/chezmoi init Limess
$HOME/.local/bin/chezmoi apply
```

To update:

```sh
chezmoi update
```
