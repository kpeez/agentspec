# AGENTS.md

This file is for coding agents. It captures language-agnostic workflow, conventions, and principles that should hold across repos.

## Scope & priority

- Obey this file first; then README.md; then in-code comments/docstrings.
- If a subdirectory has its own AGENTS.md, the closest one wins.
- Keep this file current whenever conventions change—stale guidance causes bad diffs.

## How to work on a task

1) Read this file, README.md, and any relevant language profile.
2) Inspect existing patterns before adding new ones.
3) Implement with the guidelines below.
4) Self-check: lint → types → tests (using language-appropriate tooling).
5) Verify via examples: run examples that exercise your changes.
6) Produce concise, technical notes in the PR/summary (what changed, why, risks).

## Verification via examples

For features that produce executable code, "done" means "ran it successfully"—not just "wrote it."

### Per-spec examples (default)

Add `examples/` to the spec folder for feature-specific verification:

```text
specs/<feature>/
├── design.md
├── ledger.md
├── examples/
│   ├── basic_usage.py    # minimal working example
│   └── TEST_LOG.md       # execution results
```

Keep these atomic and focused—one example per behavior you're verifying.

### Project-wide examples (optional)

For libraries or frameworks, maintain a top-level `examples/` or `cookbook/` directory:

```text
examples/              # or cookbook/
├── getting-started/
│   ├── README.md
│   ├── hello_world.py
│   └── TEST_LOG.md
├── advanced-patterns/
│   └── ...
```

Use for user-facing tutorials, pattern demonstrations, or integration scenarios.

### TEST_LOG.md format

After running an example, log the result:

```markdown
### basic_usage.py
**Status:** PASS
**Date:** 2025-01-15
**Description:** Verifies the auth flow with valid credentials.
**Result:** Token returned, expires_in=3600.
---
```

Update this log every time you run the example. Treat example failures as spec failures—don't mark a feature done until examples pass.

### Workflow integration

1. Write or update examples that exercise your changes
2. Run each example
3. Update TEST_LOG.md with PASS/FAIL and observations
4. Fix failures before considering the task complete

> **Tip:** If an example fails, that's signal—either the code is wrong or the example's expectations are stale. Investigate before moving on.

## Feature specs (context continuity)

The `specs/` folder contains design documents for current tasks. They preserve context across sessions, enabling any new agent to pick up where the last left off.

**Always read the design document before jumping into doing work!**

> **Tip:** Store specs in a cloud-synced location (`~/Documents/specs/<repo>/`) and symlink into each repo for backup and portability.

Each spec lives in its own folder: `specs/<feature>/` with the following files (created by `/spec new`):

```text
specs/<feature>/
├── AGENTS.md           # Spec-specific instructions (always read first)
├── CLAUDE.md           # References AGENTS.md for Claude Code auto-discovery
├── design.md           # Source of truth: technical approach, architecture, data flow
├── ledger.md           # Current status and what's done
├── decisions.md        # Captures the "why" (i.e., decision traces)
├── future-work.md      # What's deferred, ideas for later improvements
└── examples/           # Optional: runnable verification examples
    ├── basic_usage.py
    └── TEST_LOG.md
```

4Keep them lightweight: a one-liner is fine if there's nothing to say yet. The structure prompts thinking and helps future sessions know where to look.

### Ledger example

```markdown
# specs/<feature>/ledger.md

## What
<1-2 sentences: what we're building>

## Ledger
- **Phase**: design | implementing | testing | done
- **Blocked**: no | yes (reason)

## Done
- [x] completed item

## Next
- [ ] next item
- [ ] after that

## Context
<gotchas, non-obvious things, key files touched>
```

### Decisions

When making non-obvious technical choices, append to `specs/<feature>/decisions.md`:

```markdown
## <Decision Title>
**Context**: <why this decision was needed>
**Decision**: <what we chose>
**Alternatives**: <what else was considered>
**Rationale**: <why this option>
```

Don't create ceremony - only log decisions that future-you would wonder about.

### Skills

- `/spec new <name>` — create a new feature spec
- `/handoff` — capture session context before ending

### Workflow

1. Check `specs/` when starting work on a feature
2. Read the AGENTS.md (and/or CLAUDE.md) in that folder
3. Review the `design.md` if needed
4. Check `ledger.md` for current status and next tasks
5. Update `ledger.md` as you work (especially Done/Next/Context)

### Auto-discovery

**Important**: `specs/` is gitignored and won't appear in search results or @ autocomplete. Always check explicitly by listing the directory path.

When starting ANY task:

1. List `specs/` directory at project root (even if it doesn't appear in searches)
2. If specs exist, read the relevant spec's `AGENTS.md` and `ledger.md` before proceeding
3. Only create a new spec (`/spec new`) if no matching spec exists

---

## Coding design principles

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- **State assumptions explicitly** — If uncertain, ask rather than guess
- **Present multiple interpretations** — Don't pick silently when ambiguity exists
- **Push back when warranted** — If a simpler approach exists, say so
- **Stop when confused** — Name what's unclear and ask for clarification

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

Combat the tendency toward overengineering:

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

**The test:** Would a senior engineer say this is overcomplicated? If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

**The test:** Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform imperative tasks into verifiable goals:

| Instead of...    | Transform to...                                       |
|------------------|-------------------------------------------------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug"    | "Write a test that reproduces it, then make it pass"  |
| "Refactor X"     | "Ensure tests pass before and after"                  |

For multi-step tasks, state a brief plan:

<plan>
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
</plan>
