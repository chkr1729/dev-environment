# Mac workflow plan — Oct 2026

Audit of the M5 Pro MacBook Pro (16", 18-core CPU / 20-core GPU, 64 GB, 2 TB, macOS 26.6) on 2026-10-27,
after the Oct 19–27 migration passes. Daily drivers: Chrome, iTerm2, Claude Code in iTerm2.

## 1. Verdict

The foundation is solid. Security, backup, shell, dotfiles and the Claude Code + iTerm integration are
done well. What's left is (a) a little drift and cruft, and (b) workflow habits that make use of a machine
this powerful: parallel Claude sessions, voice prompting, local models, and less hand-switching between
Chrome and the terminal.

### Already right
| Area | State |
|---|---|
| Security | FileVault on, firewall on, SIP on, Gatekeeper on, auto macOS updates on |
| Backup | Backblaze whole-disk, test restore done |
| Shell | zsh + p10k, 0.09 s startup, atuin, fzf/fzf-tab, zoxide, direnv, eza/bat/delta, vi mode |
| Dotfiles | `~/dev-environment`, Brewfile, `install.sh`, Claude config tracked + symlinked, pushed |
| iTerm2 | "Claude" default profile (Catppuccin auto light/dark, 100k scrollback, ⌥ = Esc+), ⌥\` hotkey drop-down running `claude` in `~/code`, cc-status hooks on every Claude event |
| Claude Code | v2.1.312, auto mode, global CLAUDE.md, curated skills/plugins, custom statusline |
| Apps | Raycast on ⌘Space, OrbStack instead of Docker Desktop, Apple Passwords + iCloud extension, superwhisper (local Whisper Turbo) |
| Git/GitHub | delta side-by-side, diff3, gh logged in (keyring) |
| Battery | 6 cycles, 100% health |

### Found in this audit
| # | Issue | Fix |
|---|---|---|
| F1 | 7 brew formulae outdated (gh, uv, pyenv, python@3.12, pipenv, redis, yt-dlp) plus cursor and whatsapp casks | `update` alias (`brew update && brew upgrade && brew cleanup`) |
| F2 | Brewfile lists `mactex` and `adobe-acrobat-reader`, which were removed on Oct 26; it's missing the Cursor extensions you actually use (claude-code, jupyter*) | Remove the two casks; `brew bundle dump --force` or hand-edit the vscode lines |
| F3 | Adobe leftovers after Acrobat removal: `/Library/LaunchAgents/com.adobe.GC.Invoker-1.0.plist`, `/Library/LaunchDaemons/com.adobe.agsservice.plist`, `~/Library/Application Support/Adobe` | Unload and trash them (needs sudo) |
| F4 | Brewfile cruft: `lsd` (duplicates eza), `pipenv` (uv replaces it), `gcc@12`, `wxwidgets`, `codecrafters` | Remove whatever you no longer use |
| F5 | `install.sh` still links `alacritty` (Alacritty was removed) | Drop the link and the submodule |
| F6 | Python has four managers: pyenv, conda, uv, pipenv | Standardise: uv for every project, pyenv only for the global interpreter, conda only for hummingbot/manim/pymc |
| F7 | SSH key is old-style `id_rsa`; no `UseKeychain`/`AddKeysToAgent`; commits unsigned | New ed25519 key, Keychain in `~/.ssh/config`, optional SSH commit signing (`gpg.format=ssh`) |
| F8 | Display sleep is 180 min | 10 min on battery, 30 on power (`pmset -b displaysleep 10; pmset -c displaysleep 30`) |
| F9 | iTerm2 shell integration not installed (p10k only emits prompt marks) | Install it, for ⌘⇧↑/↓ prompt jumps, "alert when command finishes", ⌘-click paths, current-dir tab titles |
| F10 | Only `hft-mm-system` has a CLAUDE.md; `vol-lab` and `alpha-factory` have none | Run `/init` in each, then trim |
| F11 | `hft-mm-system/.claude/worktrees/` has stray `.claude/` and `logs/` dirs, plus two worktrees (`nse-phase0-ec2`, `positions-pr1`) from Sep whose branches aren't merged by name | Check whether they were squash-merged; remove finished ones |
| F12 | Chrome asks where to save each download (this broke downloads once before, Oct 20) | Settings → Downloads → turn off "Ask where to save" (verify) |
| F13 | No Time Machine | Optional: a cheap SSD for fast local restores (Backblaze restores are slow) |

Carry-overs from earlier passes (still open): fix the 6 compromised passwords; delete Google's password copies
around Nov 9; empty Photos "Recently Deleted"; remove Drive "Computers → My MacBook Pro".

## 2. Core workflow: Chrome ↔ iTerm2 ↔ Claude Code

### 2a. iTerm2 layout
- **One window per project, tabs per task.** Use the Claude profile's "Recycle" directory: ⌘T opens in the
  same repo.
- **Split panes for Claude + shell:** ⌘D (vertical) puts Claude on the left and a plain shell on the right
  for git/tests/logs. ⌘⌥arrows move between panes; ⌘⇧Enter maximises one.
- **Hotkey window (⌥\`) for quick questions** that shouldn't pollute a project session.
- **Save arrangements** (Window → Save Window Arrangement) per project, e.g. "hft" = Claude + shell +
  `tail -f logs`. Restore with ⌘⇧R.
- **cc-status tabs:** the tab colour/badge shows which Claude session is waiting on you. With 3–4
  sessions in parallel, scan tab colours instead of clicking through.
- **tmux only for remote work:** on `nse-ec2`, use `ssh nse-ec2 -t tmux -CC new -A -s main`. iTerm renders
  the remote tmux as native tabs, and Claude/long jobs survive disconnects.

### 2b. Claude Code habits that pay off on 64 GB
- **Run sessions in parallel with worktrees.** One session per independent task, each in
  `<repo>/.claude/worktrees/<name>` (ask Claude to create one). Plan in one
  pane, implement in another, review in a third.
- **Plan first for anything non-trivial.** Shift+Tab into plan mode; approve, then let it run end to end
  (matches your CLAUDE.md).
- **Voice-first prompting.** Hold right ⌘ (superwhisper) and talk through the context. Long, rich prompts
  cost you nothing by voice.
- **Hand off with images.** Screenshot to clipboard (hold Ctrl with ⌘⇧4) and paste straight into Claude with Ctrl+V.
- **Background tasks:** `/loop` to poll CI or a backtest, `/schedule` for recurring cloud agents (e.g. a
  nightly NSE data sanity check), and Remote Control or claude.ai/code to watch sessions from your phone.
- **Review before merge:** `/code-review` on the branch; `/simplify` for cleanup passes.
- **Statusline:** add 5-hour usage and session cost so you see limits before you hit them.
- **Keep context lean:** `/clear` between unrelated tasks; `/compact` deliberately; put durable facts in
  the repo CLAUDE.md, not in chat.

### 2c. Chrome
- **Claude in Chrome is installed.** Use it from Claude Code for browser tasks: reading dashboards,
  checking a deployed page, filling forms, scraping docs into a repo. It drives your real logged-in Chrome.
- **Tabs:** 14 tabs in one window is fine. Use tab groups per context (Work / Trading / Personal) and
  ⌘⇧A for tab search instead of hunting.
- **Site search shortcuts** (Settings → Search engine → Site search): `gh` → GitHub search, `nse` → NSE
  quote, `py` → Python docs, `cc` → claude.ai/code. Type `gh⇥query` in the omnibox.
- **Profiles:** one profile today. Create a separate "Millennium" profile when work starts (~Apr 2027) so
  work SSO, extensions and history never mix with personal.
- **Memory Saver** (check it's on) puts background tabs to sleep. Exempt trading/broker tabs (Settings → Performance) so
  they never reload mid-session.
- **Keys:** ⌘L omnibox, ⌘⇧T reopen tab, ⌘1–9 jump to tab, ⌘⌥←/→ previous/next tab, ⌘⇧C inspect.

### 2d. Raycast as the glue
- Window management (replaces dragging): assign hotkeys such as ⌃⌥←/→ for halves and ⌃⌥Enter for maximise. Put Chrome and iTerm side by side
  on the 16" screen.
- Clipboard history (⌘⇧V), snippets, quicklinks (open `~/code/<repo>` in iTerm, open GitHub PRs).
- Script commands: one-key "new Claude session in repo X".

## 3. Things to explore (ordered by payoff)
1. **Local LLMs.** 64 GB unified memory runs 30B–70B quantised models well. Try LM Studio or Ollama, plus
   MLX for your own experiments. Useful for private data (positions, broker statements) you don't want in
   any cloud.
2. **MLX / Metal for quant work.** The 20-core GPU accelerates PyTorch (MPS) and MLX for vol-surface fitting,
   Monte Carlo and backtests; benchmark one vol-lab notebook on CPU vs MPS.
3. **OrbStack Linux machines.** Lightweight amd64/arm64 Linux VMs for reproducing EC2 environments locally
   before shipping to `nse-ec2`.
4. **Claude Code automation.** Hooks beyond cc-status (e.g. auto-run `ruff`/`clang-format` after edits),
   project-level skills for repeated hft workflows, and `/fewer-permission-prompts`.
5. **Obsidian as the second brain.** Daily trading journal + research notes; Claude can read/write the
   vault as plain markdown.
6. **Continuity.** iPhone Mirroring (already in the Dock), Universal Clipboard, AirDrop, Continuity Camera
   for Zoom.
7. **Focus modes.** A "Trading hours" focus that silences WhatsApp/mail during the NSE session.

## 4. Plan

| Phase | Tasks | Who | Time |
|---|---|---|---|
| **1. Hygiene** | F1 brew upgrade · F2/F4 Brewfile trim + commit · F5 install.sh · F3 Adobe remnants · F8 display sleep · F12 Chrome downloads | Claude (sudo bits by you) | 20 min |
| **2. Terminal** | F9 iTerm shell integration · project window arrangements · tmux -CC alias for nse-ec2 · statusline usage/cost | Claude | 30 min |
| **3. Repos** | F10 CLAUDE.md for vol-lab and alpha-factory · F11 worktree cleanup · F6 move vol-lab/alpha-factory to uv | Claude, with your review | 1 h |
| **4. Security** | F7 ed25519 key + Keychain + commit signing · compromised passwords | Claude + you (GitHub key upload) | 20 min |
| **5. Habits** (1 week) | Parallel worktree sessions · voice prompts · Chrome tab groups + site search · Raycast window keys | You | ongoing |
| **6. Explore** | Local LLM (LM Studio) · MPS benchmark · Obsidian journal · Trading focus mode | You, Claude assists | as interested |
