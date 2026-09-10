#!/bin/sh
# Installs herdr plugins:
# - kryptamine/herdr-auto-title: sets each pane's title from the Claude Code session topic.
# - devashish2203/herdr-worktrunk: worktree switch/create/remove/merge pickers driven by `wt`
#   (worktrunk, fzf, jq come from the Brewfile). Keybindings live in ~/.config/herdr/config.toml.
set -eu

command -v herdr >/dev/null 2>&1 || exit 0

installed="$(herdr plugin list 2>/dev/null || true)"
needs_restart=0

for repo in kryptamine/herdr-auto-title devashish2203/herdr-worktrunk; do
  if ! printf '%s' "$installed" | grep -q "$repo"; then
    herdr plugin install "$repo" --yes
    needs_restart=1
  fi
done

# Startup-hook plugins (auto-title) only load on a fresh server. Do not stop a
# server that has live panes; it restarts on next use once idle.
if [ "$needs_restart" = 1 ] && [ "$(herdr pane list 2>/dev/null | grep -c '"pane_id"')" = 0 ]; then
  herdr server stop || true
fi

# Re-run the claude integration so its hooks match the installed plugin version.
herdr integration install claude
