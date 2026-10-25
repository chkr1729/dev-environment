# MacBook Pro (M5 Pro) setup plan — started 2026-10-25

Ordered by risk: safe, reversible changes first; uninstalls and sudo steps later, one at a time.

- [x] **1. macOS defaults** (done 2026-10-25, firewall on) — `scripts/macos-defaults.sh`: autocorrect / smart quotes / smart dashes off,
      fixed Spaces order, no Dock recents, Finder list view, screenshots → ~/Pictures/Screenshots.
      Firewall on (sudo, run by user).
- [x] **2. Claude Code** (done 2026-10-25) — remove duplicate npm + /usr/local installs; trim cc-status hooks to
      Notification/PermissionRequest/Stop/UserPromptSubmit; `verbose` off; `/terminal-setup`.
- [x] **3. tmux** (done 2026-10-25, resurrect+continuum on) — truecolor override, extended-keys, allow-passthrough, focus-events;
      fix continuum (enable resurrect or drop continuum).
- [x] **4. Rosetta apps → Apple Silicon** — done 2026-10-25: Raycast 2.9, Zoom 7.2.2, Wireshark 4.6.9
      (arm64 casks), yt-dlp installed. Pending (user): run OpenVPN uninstaller (no longer needed);
      trash Blender (not used), Free YouTube Downloader, texmaker; LaTeX Workshop in Cursor.
- [x] **5. Orphaned launch agents/daemons** — all removed 2026-10-25 (Omnissa, WS1, OpenVPN, VirtualBox, Java, Citrix, Wrike, Workpuls).
      Pending (user, sudo): OpenVPN/VirtualBox/Java/Citrix/Wrike/Adobe CCX leftovers, old Adobe NPAPI
      plugins, Anaconda-Navigator link, Workpuls. Acrobat Reader kept (USCIS forms); Preview as PDF default.
- [x] **6. Dock + Chrome** (done 2026-10-25; Comet removed) — Chrome/iTerm in Dock; remove duplicate mavensecurities profile, name
      profiles; Memory/Energy Saver; uBlock Origin Lite; pick one browser.
- [x] **7. Terminal consolidation** (done 2026-10-25: iTerm2 kept) — keep iTerm2 (or trial Ghostty); remove kitty/WezTerm/Alacritty.
- [x] **8. Apps & Homebrew** (done 2026-10-25: OrbStack, brew upgrade, casks adopted) — OrbStack instead of Docker Desktop, Preview instead of Adobe Reader,
      `brew upgrade`, move manually installed apps to casks, `brew bundle dump` into Brewfile.
- [x] **9. Shell** (done 2026-10-25: startup 0.35s → 0.09s; conda lazy-loaded, pyenv --no-rehash, atuin on Ctrl-R, uv installed)
- [x] **10. Commit dotfiles** (done 2026-10-25) — including the pending nvim/alacritty changes.
