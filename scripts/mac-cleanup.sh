#!/usr/bin/env bash
# Routine macOS disk maintenance. Dry run by default; pass --apply to act.
# Files go to the Trash (/usr/bin/trash), caches are cleared with each tool's own command.
set -uo pipefail

APPLY=0
[[ "${1:-}" == "--apply" ]] && APPLY=1

run() {
  if (( APPLY )); then echo "+ $*"; "$@"; else echo "[dry-run] $*"; fi
}

section() { printf '\n== %s ==\n' "$1"; }

section "Package manager caches"
command -v npm  >/dev/null && { du -sh ~/.npm/_cacache 2>/dev/null; run npm cache clean --force; }
command -v brew >/dev/null && { du -sh "$(brew --cache)" 2>/dev/null; run brew cleanup --prune=all; }
command -v pip3 >/dev/null && run pip3 cache purge
conda --version >/dev/null 2>&1 && run conda clean --all --yes

section "Downloads: installers older than 7 days"
while IFS= read -r -d '' f; do
  du -sh "$f"; run trash "$f"
done < <(find ~/Downloads -maxdepth 1 -type f \( -name '*.dmg' -o -name '*.pkg' \) -mtime +7 -print0)

section "Downloads: browser '(1)' copies identical to the original"
while IFS= read -r -d '' dup; do
  orig="${dup/ (1)/}"
  if [[ -f "$orig" ]] && cmp -s "$dup" "$orig"; then
    du -sh "$dup"; run trash "$dup"
  fi
done < <(find ~/Downloads -maxdepth 1 -type f -name '* (1).*' -print0)

section "Rebuildable dev artifacts (report only)"
find ~/code -type d \( -name node_modules -o -name .venv -o -name venv -o -name build -o -name target \) \
  -prune -print0 2>/dev/null | xargs -0 du -sh 2>/dev/null | sort -rh | head -15

section "Largest items in home"
du -sh ~/* 2>/dev/null | sort -rh | head -10
df -h /System/Volumes/Data | tail -1

(( APPLY )) || printf '\nDry run only. Re-run with --apply, then empty the Trash to reclaim space.\n'
