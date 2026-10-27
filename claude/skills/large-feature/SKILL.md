---
name: large-feature
description: Use ONLY when the user invokes /large-feature explicitly. Runs the full superpowers flow with no shortcuts — design doc, worktree isolation, subagent-driven implementation, code review, full CI on the final commit. For cross-module work, public API changes, schema or wire-format changes, new abstractions, or anything where a mistake corrupts persistent state.
disable-model-invocation: true
---

# Large Feature Mode

The user has invoked `/large-feature`. This is the case the full ceremony exists for. Schema mistakes corrupt persistent data. IPC mistakes show up as silent ring corruption. New abstractions outlive their authors. Take the time.

Apply the user's CLAUDE.md instructions on top of this skill; if their workflow-weight table differs, theirs wins.

## What "large" means

A task is large if any of these is true:

- Touches more than one module/subsystem
- Changes a public API, message schema, wire format, or persisted-state format
- Introduces a new abstraction other modules must learn
- Changes IPC topology (channels, ring layout, fan-out)
- Modifies a versioned schema constant (e.g., `SCHEMA_VERSION`, `kSchemaVersion`)
- The user describes it as "refactor", "restructure", or "redesign"

If you are uncertain whether a task is medium or large, ask. Don't guess down — defaulting to `/medium-feature` for a large task means skipping the design doc, which is the worst place to cut corners.

## Protocol

### 1. Read the lay of the land — parallel research

Use `superpowers:dispatching-parallel-agents` from the start. For a large task, the research phase typically reads 5–10 files, all of which can be read in parallel:

- All affected module READMEs
- The cleanup or refactor roadmap if one exists (look for `docs/plans/*roadmap*` or similar)
- The relevant cross-cutting docs (architecture, invariants, contributing)
- The current implementations being changed

If the project has an active cleanup or refactor roadmap, **read it before proposing the design**. Workstream dependencies often dictate ordering.

### 2. Worktree isolation — `superpowers:using-git-worktrees`

Use a git worktree. Large work spans many commits and may need to be paused mid-flight; isolation prevents stomping on the user's other work.

Branch name: `feat/<topic>` or `refactor/<topic>` per the project's commit style.

### 3. Brainstorm — `superpowers:brainstorming`

Run brainstorming. Surface alternatives, tradeoffs, and a recommendation. For large work, expect the user to push back or redirect — wait for explicit approval before writing the design doc.

### 4. Design doc — required

Large tasks get a design doc on disk. Typical location: `docs/plans/YYYY-MM-DD-<topic>-design.md` or per the project's plans-directory convention. The doc captures:

- Problem statement and motivation
- Proposed design with diagrams or pseudocode
- Alternatives considered and why rejected
- Migration plan if persistent state or schemas change
- Rollback plan
- Doc updates required (which READMEs, which cross-cutting docs)

Wait for user approval on the design before writing the implementation plan.

### 5. Plan — `superpowers:writing-plans`

Write the implementation plan as a separate doc: `docs/plans/YYYY-MM-DD-<topic>-plan.md`. Plans break the design into ~5–7 fat tasks (not one-per-file). Mechanical batches can be a single task.

### 6. Execute — `superpowers:executing-plans` or `superpowers:subagent-driven-development`

For independent tasks, use `subagent-driven-development` so they run in parallel. For tasks with sequential dependencies, use `executing-plans`. Each task uses TDD per the project's testing methodology.

### 7. Verification — scoped during, full at the end

During implementation: scope verification to the affected module's tests. Full CI on every commit is wasted minutes.

On the final commit before review: run the project's canonical full verification (e.g., `scripts/run_ci_locally.sh`). Confirm output before claiming done.

### 8. Doc coverage — broader than medium

Update:

- All affected module READMEs in the same commit as the code
- Cross-cutting docs (architecture, invariants, contributing) if behavior, structure, or rules changed
- The cleanup roadmap if this completes or modifies a workstream
- Move completed plans to the project's archive location (often `docs/plans/_completed/YYYY-MM/`)

### 9. Code review — `superpowers:requesting-code-review`

Dispatch the code-reviewer subagent. For large tasks, also dispatch a domain-specialist reviewer if one fits (security-reviewer for auth/payments, performance-analyzer for hot paths). Self-review with `superpowers:receiving-code-review` before responding to feedback.

### 10. Finish — `superpowers:finishing-a-development-branch`

Use the finishing skill to decide PR vs. merge vs. cleanup based on the project's workflow.

## When to break out

Stop and surface to the user if any become true:

- The design conflicts with an active workstream in the cleanup roadmap → propose to defer or reorder
- A subagent task turns up a bug unrelated to this feature → file it, do not fix in this PR
- The migration plan reveals data loss risk → escalate before writing code
- Scope shrinks substantially mid-flight (the cross-cutting concern turns out to be local) → propose downgrading to `/medium-feature`

## What this skill does NOT do

- Does not skip the design doc
- Does not skip the worktree
- Does not skip code review
- Does not allow doc updates to be deferred
- Does not skip full CI on the final commit
