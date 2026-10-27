#!/bin/bash
input=$(cat)
user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd="$PWD"
short="${cwd/#$HOME/\~}"
branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
model=$(echo "$input" | jq -r '.model.id // empty')
rem=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

out="${user}@${host} ${short}"
[ -n "$branch" ] && out="$out [$branch]"
[ -n "$model" ] && out="$out | $model"
[ -n "$rem" ] && out="$out | ctx: $(printf '%.0f' "$rem")% remaining"
[ -n "$cost" ] && out="$out | \$$(printf '%.2f' "$cost")"
[ -n "$five" ] && out="$out | 5h: $(printf '%.0f' "$five")%"
[ -n "$week" ] && out="$out · 7d: $(printf '%.0f' "$week")%"

echo "$out"
