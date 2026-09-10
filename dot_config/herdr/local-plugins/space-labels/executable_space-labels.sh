#!/usr/bin/env bash
# Polls herdr and reports per-workspace display tokens for the Spaces sidebar:
#   $repo  - basename of the repo's primary checkout (shared by all its worktrees)
#   $kind  - icon: ICON_WORKTREE for a linked worktree, ICON_MAIN for the primary checkout
#   $label - workspace custom name; falls back to branch when the name is just the dir basename
#   $title - "$repo $label" as one token, for a compact primary row
# Only worktree.created / terminal.closed plugin events exist, so polling is the
# only way to track renames and branch switches.
set -u
HERDR="${HERDR_BIN_PATH:-herdr}"
INTERVAL="${SPACE_LABELS_INTERVAL:-5}"
ICON_WORKTREE="${SPACE_LABELS_ICON_WORKTREE:-⑂}"
ICON_MAIN="${SPACE_LABELS_ICON_MAIN:-⌂}"
SOURCE="local.space-labels"

# Repo names over 3 chars are abbreviated: initials of hyphen/underscore-separated words
# (vendor-service -> vs, developer-hub -> dh), or the first 3 chars of a single word.
abbrev() {
  local name="$1" words initials=""
  [ "${#name}" -le 3 ] && { printf '%s' "$name"; return; }
  IFS='-_' read -ra words <<<"$name"
  if [ "${#words[@]}" -gt 1 ]; then
    for w in "${words[@]}"; do initials+="${w:0:1}"; done
    printf '%s' "$initials"
  else
    printf '%s' "${name:0:3}"
  fi
}

report() {
  local ws="$1"; shift
  "$HERDR" workspace report-metadata "$ws" --source "$SOURCE" --seq "$seq" "$@" >/dev/null 2>&1
}

while :; do
  # Wall-clock seq so a restarted loop is not ignored as stale by herdr.
  seq="$(date +%s%3N)"
  panes="$("$HERDR" pane list 2>/dev/null)" || { sleep "$INTERVAL"; continue; }
  spaces="$("$HERDR" workspace list 2>/dev/null)" || { sleep "$INTERVAL"; continue; }

  # workspace_id<TAB>label<TAB>first pane cwd
  jq -rn --argjson p "$panes" --argjson s "$spaces" '
    ($p.result.panes | group_by(.workspace_id) | map({key: .[0].workspace_id, value: (.[0].foreground_cwd // .[0].cwd)}) | from_entries) as $cwd
    | $s.result.workspaces[] | [.workspace_id, .label, ($cwd[.workspace_id] // "")] | @tsv
  ' | while IFS=$'\t' read -r ws label cwd; do
    [ -n "$cwd" ] && [ -d "$cwd" ] || continue
    if git_dir="$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)"; then
      common="$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)"
      top="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)"
      branch="$(git -C "$cwd" branch --show-current 2>/dev/null)"
      [ -n "$branch" ] || branch="$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)"
      # git-common-dir is the primary checkout's .git; its parent is the repo root.
      case "$common" in /*) ;; *) common="$cwd/$common" ;; esac
      repo="$(abbrev "$(basename "$(dirname "$common")")")"
      if [ "$(cd "$cwd" && realpath "$git_dir")" = "$(realpath "$common")" ]; then kind="$ICON_MAIN"; else kind="$ICON_WORKTREE"; fi
    else
      top="$cwd"; branch=""; repo=""; kind=""
    fi
    if [ "$label" = "$(basename "$top")" ] || [ "$label" = "$(basename "$cwd")" ] || [ -z "$label" ]; then
      out="$branch"
    else
      out="$label"
    fi
    [ -n "$out" ] || out="$(basename "$cwd")"
    # $title = "<repo> <label>" as one token: herdr inserts " · " between separate tokens.
    args=(--token "label=$out" --token "title=${repo:+$repo }$out")
    if [ -n "$repo" ]; then args+=(--token "repo=$repo" --token "kind=$kind"); else args+=(--clear-token repo --clear-token kind); fi
    report "$ws" "${args[@]}"
  done
  sleep "$INTERVAL"
done
