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

## Troubleshooting

### Cask install fails to unquarantine (`Failed to unquarantine app bundle`)

Since macOS Sequoia, stripping a cask's quarantine attribute (which some cask
installer scripts do themselves, e.g. `private-internet-access`) requires
your terminal app to hold the **App Management** privacy permission. Without
it, both the cask's installer script and a manual `sudo xattr -dr
com.apple.quarantine ...` fail with `Operation not permitted`, even as root.

To fix:

1. Open **System Settings → Privacy & Security → App Management**.
2. Enable the toggle for your terminal app (Terminal, iTerm2, Ghostty, etc.).
3. Restart the terminal app.
4. Re-run `brew install --cask <name>`, or manually clear the attribute:
   ```sh
   sudo xattr -dr com.apple.quarantine "/Applications/<App Name>.app"
   ```

Apple does not expose a way to grant this permission from a script or
`tccutil` — it requires a manual click in System Settings (or an MDM-pushed
PPPC profile), so this step can't be automated by chezmoi.
