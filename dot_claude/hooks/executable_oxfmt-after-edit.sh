#!/usr/bin/env bash
set -euo pipefail

format_file() {
  local file_path="$1"
  case "$file_path" in
    *.ts|*.tsx|*.mts|*.cts|*.js|*.jsx|*.mjs|*.cjs) ;;
    *) return 0 ;;
  esac

  local directory
  directory=$(dirname "$file_path")
  while [ "$directory" != "/" ]; do
    if [ -x "$directory/node_modules/.bin/oxfmt" ]; then
      "$directory/node_modules/.bin/oxfmt" --write --ignore-path=/dev/null "$file_path" >/dev/null 2>&1
      return 0
    fi
    directory=$(dirname "$directory")
  done
}

if [ -n "${1:-}" ]; then
  format_file "$1"
  exit 0
fi

payload=$(cat)
file_path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // .tool_input.filePath // .tool_input.path // empty')
if [ -n "$file_path" ]; then
  format_file "$file_path"
  exit 0
fi

patch=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')
while IFS= read -r line; do
  case "$line" in
    '*** Update File: '*|'*** Add File: '*)
      format_file "${line#*: }"
      ;;
  esac
done <<< "$patch"
