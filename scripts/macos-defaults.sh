#!/usr/bin/env bash
# Opinionated macOS defaults for a terminal-heavy dev Mac. Idempotent; safe to rerun.
# Undo any line with `defaults delete <domain> <key>`.
set -euo pipefail

# Typing: no autocorrect or smart punctuation (breaks pasted commands and code)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Fast key repeat, no accent popup (vim-friendly)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Dock: no recent apps, keep Spaces in a fixed order
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Finder: list view, path bar, all extensions
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder ShowPathbar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Screenshots out of the iCloud-synced Desktop
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

killall Dock Finder SystemUIServer 2>/dev/null || true
echo "Done. Some settings (typing) apply to apps after they relaunch."
