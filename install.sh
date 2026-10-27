#!/usr/bin/env bash
# Bootstrap this dotfile repo on a new macOS machine.
# Idempotent: safe to re-run.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Repo: $REPO"

# Initialize submodules (alacritty themes)
git -C "$REPO" submodule update --init --recursive

# Symlink helper: link <target-in-repo> <home-path>
link() {
  local target="$1" linkpath="$2"
  if [ -L "$linkpath" ] && [ "$(readlink "$linkpath")" = "$target" ]; then
    echo "OK   $linkpath"
    return
  fi
  if [ -e "$linkpath" ] || [ -L "$linkpath" ]; then
    local backup="$linkpath.backup.$(date +%Y%m%d-%H%M%S)"
    echo "BACK $linkpath -> $backup"
    mv "$linkpath" "$backup"
  fi
  mkdir -p "$(dirname "$linkpath")"
  ln -s "$target" "$linkpath"
  echo "LINK $linkpath -> $target"
}

# Shell
link "$REPO/zsh/.zshrc"        "$HOME/.zshrc"
link "$REPO/zsh/.zprofile"     "$HOME/.zprofile"
link "$REPO/zsh/.p10k.zsh"     "$HOME/.p10k.zsh"
link "$REPO/zsh/.zsh_aliases"  "$HOME/.zsh_aliases"
link "$REPO/bash/.bash_profile" "$HOME/.bash_profile"
link "$REPO/bash/.bashrc"      "$HOME/.bashrc"

# Git
link "$REPO/git/.gitconfig"    "$HOME/.gitconfig"

# Tmux
link "$REPO/tmux/tmux.conf"    "$HOME/.tmux.conf"

# XDG configs
link "$REPO/nvim"              "$HOME/.config/nvim"
link "$REPO/alacritty"         "$HOME/.config/alacritty"

# Claude Code (user-level config; runtime state stays in ~/.claude)
link "$REPO/claude/settings.json"         "$HOME/.claude/settings.json"
link "$REPO/claude/CLAUDE.md"             "$HOME/.claude/CLAUDE.md"
link "$REPO/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
for skill in "$REPO"/claude/skills/*/; do
  link "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
done

# iTerm2 dynamic profiles (Claude + Claude Hotkey)
link "$REPO/iterm2/claude-profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/claude-profiles.json"

# Optional: restore Brew packages (run manually if you want this)
if [ "${INSTALL_BREW:-0}" = "1" ] && [ -f "$REPO/Brewfile" ]; then
  brew bundle --file="$REPO/Brewfile"
fi

echo "Done. Open a new shell."
