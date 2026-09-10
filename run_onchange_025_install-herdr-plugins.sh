#!/bin/sh
# Installs herdr plugins:
# - kryptamine/herdr-auto-title: sets each pane's title from the Claude Code session topic.
# - devashish2203/herdr-worktrunk: worktree switch/create/remove/merge pickers driven by `wt`
#   (worktrunk, fzf, jq come from the Brewfile).
# - jhochenbaum/herdr-hunk-diff: review agent diffs in hunk and send comments back (needs node).
# - local space-labels plugin (dot_config/herdr/local-plugins): $title/$repo/$kind/$label sidebar tokens.
# Keybindings for all of them live in the chezmoi-managed ~/.config/herdr/config.toml, so
# hunk-diff's `setup-keys` is intentionally not run here.
set -eu

command -v herdr >/dev/null 2>&1 || exit 0

installed="$(herdr plugin list 2>/dev/null || true)"
needs_restart=0

for repo in kryptamine/herdr-auto-title devashish2203/herdr-worktrunk jhochenbaum/herdr-hunk-diff; do
  if ! printf '%s' "$installed" | grep -q "$repo"; then
    HUNKDIFF_PACKAGE_MANAGER=pnpm herdr plugin install "$repo" --yes
    needs_restart=1
  fi
done

if ! printf '%s' "$installed" | grep -q 'local.space-labels'; then
  herdr plugin link "$HOME/.config/herdr/local-plugins/space-labels" --enabled
  needs_restart=1
fi

# Startup-hook plugins (auto-title, space-labels) only load on a fresh server. Do not
# stop a server that has live panes; it restarts on next use once idle.
if [ "$needs_restart" = 1 ] && [ "$(herdr pane list 2>/dev/null | grep -c '"pane_id"')" = 0 ]; then
  herdr server stop || true
fi

# Re-run the claude integration so its hooks match the installed plugin version.
herdr integration install claude
