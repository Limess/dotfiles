#!/usr/bin/env bash
# Polls herdr and reports per-workspace display tokens for the Spaces sidebar:
#   $repo - basename of the repo's primary checkout (shared by all its worktrees)
#   $kind - ICON_WORKTREE for a linked worktree, ICON_MAIN for the primary checkout
# Only worktree.created / terminal.closed plugin events exist, so polling is the
# only way to track new workspaces and moved panes.
set -u
HERDR="${HERDR_BIN_PATH:-herdr}"
INTERVAL="${SPACE_LABELS_INTERVAL:-5}"
ICON_WORKTREE="${SPACE_LABELS_ICON_WORKTREE:-⑂}"
ICON_MAIN="${SPACE_LABELS_ICON_MAIN:-⌂}"
SOURCE="local.space-labels"

while :; do
  # Wall-clock seq so a restarted loop is not ignored as stale by herdr.
  seq="$(date +%s%3N)"
  panes="$("$HERDR" pane list 2>/dev/null)" || { sleep "$INTERVAL"; continue; }

  # workspace_id<TAB>first pane cwd
  jq -r '.result.panes | group_by(.workspace_id) | .[] | [.[0].workspace_id, (.[0].foreground_cwd // .[0].cwd)] | @tsv' <<<"$panes" \
  | while IFS=$'\t' read -r ws cwd; do
    [ -n "$cwd" ] && [ -d "$cwd" ] || continue
    if git_dir="$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)"; then
      common="$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)"
      case "$common" in /*) ;; *) common="$cwd/$common" ;; esac
      # git-common-dir is the primary checkout's .git; its parent is the repo root.
      repo="$(basename "$(dirname "$common")")"
      if [ "$(cd "$cwd" && realpath "$git_dir")" = "$(realpath "$common")" ]; then kind="$ICON_MAIN"; else kind="$ICON_WORKTREE"; fi
      "$HERDR" workspace report-metadata "$ws" --source "$SOURCE" --seq "$seq" --token "repo=$repo" --token "kind=$kind" >/dev/null 2>&1
    else
      "$HERDR" workspace report-metadata "$ws" --source "$SOURCE" --seq "$seq" --clear-token repo --clear-token kind >/dev/null 2>&1
    fi
  done
  sleep "$INTERVAL"
done
