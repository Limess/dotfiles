# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Usage

To install to a new machine:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply Limess
```

To update:

```sh
chezmoi update
```
