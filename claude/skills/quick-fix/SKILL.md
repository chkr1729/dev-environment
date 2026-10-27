---
name: quick-fix
description: Use ONLY when the user invokes /quick-fix explicitly. Short-circuits superpowers ceremony for trivially small tasks — read, edit, test, commit. Skips brainstorming, plan, worktree, code-reviewer dispatch. Keeps TDD only if the change is logic.
disable-model-invocation: true
---

# Quick Fix Mode

The user has explicitly invoked `/quick-fix`, which means the task is small enough that the full superpowers flow would be overkill. Treat this as a binding instruction that overrides skill defaults — `using-superpowers` says user instructions take priority, and this is one of those instructions.

## What "small" means here

The user has judged this task to be one of:

- A typo, comment, doc tweak, or formatting fix
- A single-line config or constant change
- A targeted bugfix in a single function with an obvious cause
- A rename or mechanical refactor with no behavioral change
- A test-only change (adding a missed assertion, fixing a flaky test)

If the scope turns out larger than that — multi-file with logic changes, public API impact, schema change — **stop and tell the user**. Don't silently escalate; ask whether they want to switch to a fuller flow.

## Protocol

1. **Read what's needed, edit, done.** No brainstorming. No writing-plans. No git worktree.
2. **TDD only if the change is logic.** Pure docs/config/typo fixes don't need a test. A bugfix in a function does — write the failing test first, then the fix. This is the floor; `AGENT_PROTOCOLS.md` keeps it.
3. **Verification is local-targeted, not full Docker CI.** Run the single relevant test (`ctest -R <pattern>`) or the file-level lint. Skip `scripts/run_ci_locally.sh` unless the user asks. If the project has a memory note about CI scope, follow it.
4. **No code-reviewer subagent dispatch.** The user reviews the diff themselves.
5. **Commit when done if the user asked for a commit.** One clean conventional-commit message. No PR unless requested.
6. **Report in 1–3 sentences.** What changed, what was verified. No summary bloat.

## When to break out of quick-fix mode

Stop and surface to the user if any of these become true mid-task:

- The change touches more than ~3 files of real code (test files don't count)
- A public API, message schema, or wire format would change
- The fix requires understanding a system you haven't read
- A test you wrote fails in a way that suggests the bug is deeper than thought
- The user's stated scope and the actual scope have diverged

In those cases say: "This is bigger than a quick-fix. Want me to switch to the standard flow (brainstorm → plan → TDD)?"

## What this skill is NOT

- Not a license to skip TDD on logic changes
- Not a way to skip verification — verification is mandatory, just narrower
- Not a substitute for the standard flow on real features
