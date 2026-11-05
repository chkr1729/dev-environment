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

## Verification
- Never claim a test passed unless it was actually run.
- Run relevant tests after code changes; report failures clearly.
- Add regression tests for bug fixes.
- For nontrivial changes, verify correctness before declaring completion.
- Benchmark before and after performance optimizations.
- Distinguish implemented, tested, and verified.

## Documentation
- Keep documentation concise and structured.
- Avoid duplicating information across files.
- Prefer linking to existing documentation.
- Update durable documentation when behavior changes.
- Do not append session histories to instruction files.

## Visual communication
I understand faster from pictures than prose. Use a visual when it makes something clearer than text would; otherwise don't.

- Answer in the first line, then the visual, then 1–3 sentences on what it shows and its caveats. Don't narrate the visual.
- Pick the form by content: flows, architecture, state, decisions → diagram; comparisons and numeric summaries → table; distributions, time series, relationships, sensitivity → plot; parameter exploration → interactive page.
- Match the medium to where it's read:
  - Terminal chat: Markdown tables and small box-drawing diagrams. Mermaid shows as raw source there; don't use it in chat.
  - Files (docs, READMEs, PRs, notebooks): Mermaid for diagrams, matplotlib/plotly for plots.
  - Interactive: use an artifact/HTML publishing tool if one is available; otherwise write a self-contained HTML file and give me its path.
- Use the lightest visual that works (table < chart < interactive). No decorative or redundant visuals, none for short factual answers.
- Plots: title, axis labels with units, legend when >1 series, appropriate scales (log where relevant).
- For nontrivial algorithms or designs, show the overall flow before implementation details.
