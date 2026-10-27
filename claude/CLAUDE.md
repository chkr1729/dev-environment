# Working with me

## How to work
- Once we agree on a plan, carry it out end to end without checking in between steps. Stop only for irreversible or destructive actions, anything that spends money or touches shared/remote systems, or a genuine design decision that is mine to make.
- Answer direct questions directly: the first line is the answer, then the support.
- Prefer a few fat tasks over many micro-steps; batch mechanical changes and review them once.
- Keep deliverables concise. Don't explain what a competent quant/engineer already knows.
- When something is unclear, ask one precise question rather than a list.

## Environment
- macOS on Apple Silicon (M5 Pro), zsh, iTerm2, Homebrew at /opt/homebrew. Everything is arm64-native.
- Dotfiles live in ~/dev-environment (symlinked into $HOME). Change config there, not in the symlink targets.
- Code lives in ~/code. Put git worktrees under `<repo>/.claude/worktrees/<name>` and remove them once their branch or PR is done.
- Python: pyenv global 3.12 for scripts, uv for new projects and virtualenvs, conda (miniforge) only for existing envs (hummingbot, manim, pymc).
- Docker runs on OrbStack.
- Delete files with `trash`, not `rm -rf`.

## Git
- Don't add Claude/AI attribution (Co-Authored-By, "Generated with Claude Code") to commits, PR descriptions or code comments in my repos.

## Background
- Strong in equity/NSE options and quant finance. Explain crypto-native concepts (perps, funding, inverse contracts) by analogy to equity options.
