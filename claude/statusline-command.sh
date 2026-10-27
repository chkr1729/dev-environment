#!/bin/bash
input=$(cat)
user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd="$PWD"
short="${cwd/#$HOME/~}"
branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
model=$(echo "$input" | jq -r '.model.id // empty')
rem=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

out="${user}@${host} ${short}"
[ -n "$branch" ] && out="$out [$branch]"
[ -n "$model" ] && out="$out | $model"
[ -n "$rem" ] && out="$out | ctx: $(printf '%.0f' "$rem")% remaining"

echo "$out"
