#!/bin/bash

# Read JSON input
input=$(cat)

# Extract values
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
cd "$cwd" 2>/dev/null || exit 0

# Directory and git info
dir=$(basename "$cwd")
branch=$(git --no-optional-locks branch --show-current 2>/dev/null)
status=$(git --no-optional-locks status --porcelain 2>/dev/null)

# Context window usage
used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Model info - extract full name like "opus 4.6" from ID like "claude-opus-4-6"
model_id=$(echo "$input" | jq -r '.model.id // empty')
model_name=""
if [[ "$model_id" =~ claude-opus-([0-9]+)-([0-9]+) ]]; then
    model_name="opus ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
elif [[ "$model_id" =~ claude-sonnet-([0-9]+)-([0-9]+) ]]; then
    model_name="sonnet ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
elif [[ "$model_id" =~ claude-haiku-([0-9]+)-([0-9]+) ]]; then
    model_name="haiku ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
fi

# Cost from pre-calculated field
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
[ -n "$cost" ] && cost=$(awk "BEGIN {printf \"%.2f\", $cost}")

# Session duration
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
if [ -n "$duration_ms" ]; then
    total_secs=$((duration_ms / 1000))
    mins=$((total_secs / 60))
    secs=$((total_secs % 60))
    duration=$(printf "%dm %02ds" "$mins" "$secs")
fi

# Line 1: model, directory, branch
[ -n "$model_name" ] && printf '\033[37m%s\033[0m' "$model_name"
[ -n "$model_name" ] && printf ' \033[90m|\033[0m '
printf '\033[37m%s\033[0m' "$dir"
[ -n "$branch" ] && printf ' \033[90m|\033[0m \033[37m%s\033[0m' "$branch"
[ -n "$status" ] && printf ' \033[38;5;218m*\033[0m'

# Line 2: context bar, cost
printf '\n'

if [ -n "$used" ]; then
    bar_len=10
    filled=$(awk "BEGIN {printf \"%.0f\", ($used / 100) * $bar_len}")

    # Color based on usage: muted green (<50%), muted yellow (50-80%), muted red (>80%)
    if [ "$used" -lt 50 ]; then
        bar_color='\033[38;5;65m'
    elif [ "$used" -lt 80 ]; then
        bar_color='\033[38;5;179m'
    else
        bar_color='\033[38;5;131m'
    fi

    # Build progress bar
    bar=""
    i=0
    while [ $i -lt $filled ]; do
        bar="${bar}█"
        i=$((i + 1))
    done
    while [ $i -lt $bar_len ]; do
        bar="${bar}░"
        i=$((i + 1))
    done

    printf '%b%s\033[0m \033[37m%s%%\033[0m' "$bar_color" "$bar" "$used"
fi

[ -n "$cost" ] && printf ' \033[90m|\033[0m \033[37m$%s\033[0m' "$cost"
[ -n "$duration" ] && printf ' \033[90m|\033[0m \033[37m%s\033[0m' "$duration"
