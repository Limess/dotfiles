# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports macOS (ARM64/Intel) and Linux (WSL2).

## Common Commands

```sh
# Apply dotfiles to the current machine
chezmoi apply

# Preview changes without applying
chezmoi diff

# Edit a managed file (auto-opens source)
chezmoi edit ~/.zshrc

# Update from git remote and apply
chezmoi update

# Re-run a changed script
chezmoi apply --force

# Install to a new machine
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply Limess
```

## Architecture

### Chezmoi File Naming Conventions

- `dot_*` → `~/.*` (e.g., `dot_zshrc` → `~/.zshrc`)
- `executable_*` → file gets `+x` permission
- `private_*` → chmod 600
- `*.tmpl` → processed as Go templates before applying
- `run_once_*` → shell script run once per machine
- `run_onchange_*` → shell script run when file hash changes

### Template System

Templates use Go text/template syntax with chezmoi variables:

- `{{ .chezmoi.os }}` — `darwin` or `linux`
- `{{ .chezmoi.arch }}` — `arm64` or `amd64`
- `{{ .chezmoi.kernel.osrelease }}` — used to detect WSL2 (contains `microsoft`)
- `{{ onepasswordRead "op://vault/item/field" }}` — fetch secrets from 1Password
- `{{ lookPath "cmd" }}` — check if a command is on PATH

Cross-platform pattern:

```
{{ if eq .chezmoi.os "darwin" -}}
  ...
{{ else if (.chezmoi.kernel.osrelease | lower | contains "microsoft") -}}
  ...
{{ end }}
```

### Package Management

Packages are centrally declared in `.chezmoidata/packages.yaml` (npm globals, Python tools, Rust crates). Installation is driven by numbered `run_onchange_0NN_*` scripts that execute in order.

### Shell Configuration

Zsh config is split across `dot_zsh/`:

- `config.zsh` — history, keybindings, FZF integration
- `zstyle.zsh` — completion styling
- `aliases.zsh.tmpl` — aliases (git, kubectl, docker, brew, chezmoi shortcut `cz`)
- `env.zsh.tmpl` — environment variables, 1Password-sourced tokens

Plugin manager: **antidote** (plugin list in `dot_zsh_plugins.txt`).
Prompt: **starship** (`dot_config/starship.toml`).
Shell completions are generated into `~/.zsh/completions/` by script 023.

### Secrets

All secrets come from **1Password** via `onepasswordRead`. Nothing secret is committed. `.claude/settings.json` denies reads of `.env*` and `profiles.clj`. Local overrides (tokens, machine-specific vars) go in `~/.localrc` (not in repo).
