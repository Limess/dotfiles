#!/bin/sh
# Installs the herdr-auto-title plugin, which sets each herdr pane's title from
# the Claude Code session topic. https://github.com/kryptamine/herdr-auto-title
set -eu

command -v herdr >/dev/null 2>&1 || exit 0

if ! herdr plugin list 2>/dev/null | grep -q 'herdr-auto-title'; then
  herdr plugin install kryptamine/herdr-auto-title
  # Plugins only load on a fresh server; it restarts on next use.
  herdr server stop || true
fi

# Re-run the claude integration so its hooks match the installed plugin version.
herdr integration install claude
