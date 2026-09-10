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

# Model info - "opus 4.6" from "claude-opus-4-6"; fall back to display_name for other IDs
model_id=$(echo "$input" | jq -r '.model.id // empty')
model_name=""
if [[ "$model_id" =~ claude-([a-z]+)-([0-9]+)-([0-9]+) ]]; then
    model_name="${BASH_REMATCH[1]} ${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
elif [[ "$model_id" =~ claude-([a-z]+)-([0-9]+)$ ]]; then
    model_name="${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
else
    model_name=$(echo "$input" | jq -r '.model.display_name // empty' | tr '[:upper:]' '[:lower:]')
fi

# Account - the status line JSON has no account field, so read the logged-in OAuth account
account=$(jq -r '.oauthAccount.emailAddress // empty' "$HOME/.claude.json" 2>/dev/null)

# Plan - derived from the rate limit tier ("default_claude_max_5x" -> "max 5x") and org type ("claude_team" -> "team")
plan=$(jq -r '.oauthAccount.userRateLimitTier // empty' "$HOME/.claude.json" 2>/dev/null | sed -E 's/^default_(claude_)?//; s/_/ /g')
org_type=$(jq -r '.oauthAccount.organizationType // empty' "$HOME/.claude.json" 2>/dev/null | sed -E 's/^claude_//')
case "$org_type" in
    team|enterprise) plan="${org_type}${plan:+ $plan}" ;;
esac

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

# Print a colored progress bar followed by the percentage.
# Muted green (<50%), muted yellow (50-80%), muted red (>80%).
print_bar() {
    local pct=$1 bar_len=$2 bar_color bar="" i=0
    local pct_int
    pct_int=$(awk "BEGIN {printf \"%d\", $pct}")
    local filled
    filled=$(awk "BEGIN {printf \"%.0f\", ($pct / 100) * $bar_len}")
    [ "$filled" -gt "$bar_len" ] && filled=$bar_len

    if [ "$pct_int" -lt 50 ]; then
        bar_color='\033[38;5;65m'
    elif [ "$pct_int" -lt 80 ]; then
        bar_color='\033[38;5;179m'
    else
        bar_color='\033[38;5;131m'
    fi

    while [ $i -lt $filled ]; do
        bar="${bar}█"
        i=$((i + 1))
    done
    while [ $i -lt $bar_len ]; do
        bar="${bar}░"
        i=$((i + 1))
    done

    printf '%b%s\033[0m \033[37m%s%%\033[0m' "$bar_color" "$bar" "$pct_int"
}

# Compact time remaining until a Unix epoch timestamp, e.g. "2h15m" or "3d4h".
time_until() {
    local secs=$(( $1 - $(date +%s) ))
    [ "$secs" -lt 0 ] && secs=0
    local d=$((secs / 86400)) h=$((secs % 86400 / 3600)) m=$((secs % 3600 / 60))
    if [ "$d" -gt 0 ]; then
        printf '%dd %dh' "$d" "$h"
    elif [ "$h" -gt 0 ]; then
        printf '%dh %02dm' "$h" "$m"
    else
        printf '%dm' "$m"
    fi
}

# Line 1: model, directory, branch
[ -n "$model_name" ] && printf '\033[37m%s\033[0m' "$model_name"
[ -n "$model_name" ] && printf ' \033[90m|\033[0m '
printf '\033[37m%s\033[0m' "$dir"
[ -n "$branch" ] && printf ' \033[90m|\033[0m \033[37m%s\033[0m' "$branch"
[ -n "$status" ] && printf ' \033[38;5;218m*\033[0m'
[ -n "$account" ] && printf ' \033[90m|\033[0m \033[90m%s\033[0m' "$account"
[ -n "$plan" ] && printf ' \033[90m(%s)\033[0m' "$plan"

# Line 2: context bar, cost
printf '\n'

if [ -n "$used" ]; then
    print_bar "$used" 10
fi

# Subscription usage allowance (absent for API-key users)
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

if [ -n "$five_hour" ]; then
    printf ' \033[90m|\033[0m \033[90m5h\033[0m '
    print_bar "$five_hour" 5
    [ -n "$five_hour_reset" ] && printf ' \033[90m(%s)\033[0m' "$(time_until "$five_hour_reset")"
fi
if [ -n "$seven_day" ]; then
    printf ' \033[90m|\033[0m \033[90m7d\033[0m '
    print_bar "$seven_day" 5
    [ -n "$seven_day_reset" ] && printf ' \033[90m(%s)\033[0m' "$(time_until "$seven_day_reset")"
fi

[ -n "$cost" ] && printf ' \033[90m|\033[0m \033[37m$%s\033[0m' "$cost"
[ -n "$duration" ] && printf ' \033[90m|\033[0m \033[37m%s\033[0m' "$duration"
