#!/bin/bash
# One-time: move live ~/.claude config into ~/.claude/backups, then link the repo copies in.
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
BK="$HOME/.claude/backups/pre-dotfiles-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BK/skills"
for f in settings.json CLAUDE.md statusline-command.sh; do
  [ -L "$HOME/.claude/$f" ] || mv "$HOME/.claude/$f" "$BK/"
done
for skill in "$REPO"/claude/skills/*/; do
  name=$(basename "$skill")
  [ -L "$HOME/.claude/skills/$name" ] || { [ -e "$HOME/.claude/skills/$name" ] && mv "$HOME/.claude/skills/$name" "$BK/skills/"; }
done
"$REPO/install.sh" | grep -v '^OK'
echo "Originals backed up to $BK"
