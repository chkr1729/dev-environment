---
name: medium-feature
description: Use ONLY when the user invokes /medium-feature explicitly. Runs the full superpowers flow (brainstorm → plan → TDD → verification → code-review) but enforces parallel agent dispatch for research, scopes verification to relevant tests until the final commit, and bakes in doc-coverage reminders. For multi-file work within a single module that doesn't change public APIs or schemas.
disable-model-invocation: true
---

# Medium Feature Mode

The user has invoked `/medium-feature`. This is calibrated for tasks that need full discipline — TDD, planning, code review — but where the surface area is contained to one module and there is no schema, API, or wire-format change. Apply the user's CLAUDE.md instructions on top of this skill; if their workflow-weight table differs, theirs wins.

## What "medium" means

A task is medium if all of these are true:

- Touches multiple files but stays inside one module/subsystem
- No change to public APIs, message schemas, wire formats, or persisted state
- No new abstraction that other modules will need to learn
- Can plausibly land in a single PR with a single design conversation

If any of those breaks, **stop and ask** the user whether to escalate to `/large-feature`. Don't silently run the larger flow.

## Protocol

### 1. Research phase — parallel by default

Before brainstorming, gather context. Use `superpowers:dispatching-parallel-agents` to read the relevant files in parallel — never sequentially. Typical parallel reads:

- The module's README and main public header
- The relevant config file section (if any)
- 1–2 sibling implementations to mirror patterns from
- The test file the new tests will neighbor

Sequential reads here are the single biggest source of wall-time waste. If the task touches N independent files, dispatch N reads in one message.

### 2. Brainstorm — `superpowers:brainstorming`

Run brainstorming. Surface the design choices, the alternatives considered, and the recommendation. Wait for user approval before proceeding to plan.

### 3. Plan — `superpowers:writing-plans`

Write a tight plan. For medium work the plan can live in the conversation; do not create `docs/plans/*.md` unless the user asks. Include:

- The test that proves the feature works
- The implementation steps
- The doc updates required (READMEs, cross-cutting docs)
- The verification commands

### 4. TDD — `superpowers:test-driven-development`

Standard TDD. Write the failing test first. Run it. See it fail. Implement. Pass. Refactor.

### 5. Verification — scoped, not full

**Until the final commit:** run only the directly relevant test binary (`ctest -R <pattern>` or equivalent). Full project test suites and Docker CI are wasted minutes on intermediate commits.

**On the final commit:** run the project's canonical verification command (consult CLAUDE.md or AGENT_PROTOCOLS.md for the project-specific command). Confirm output before claiming done.

If the user has a memory rule about skipping CI in certain conditions, follow it.

### 6. Doc coverage — same commit, not follow-up

Update module README and any cross-cutting docs (architecture, invariants, contributing) **in the same commit as the code**. Never defer to a follow-up PR. If the project has a doc-coverage rule (often in AGENT_PROTOCOLS.md or CONTRIBUTING.md), apply it.

### 7. Code review — `superpowers:requesting-code-review`

Dispatch the code-reviewer subagent at completion. Self-review with `superpowers:receiving-code-review` before accepting feedback.

### 8. Commit and report

Conventional-commit style. One sentence of "what" plus context if non-obvious. Report in 3–5 sentences: what shipped, what was tested, what was reviewed.

## When to break out

Stop and surface to the user if any become true:

- Scope expands to a public API, schema, wire format, or persisted-state change → switch to `/large-feature`
- Scope shrinks to a single trivial change → switch to `/quick-fix`
- A failing test reveals a bug deeper than the original task → invoke `superpowers:systematic-debugging`
- Two parallel sessions might be touching the same files → coordinate before continuing

## What this skill does NOT do

- Does not skip TDD
- Does not skip code review
- Does not skip doc coverage
- Does not run full project CI on every intermediate commit
