---
name: spec
description: Create and manage feature specs for context continuity across agent sessions. Use when starting a new feature, checking spec status, or when user runs /spec.
---

# /spec - Feature Spec Management

## Commands

### /spec new <name>

Run: `scripts/create-spec.sh "<name>" "$PWD"`

Creates `specs/<name>/` with: AGENTS.md, design.md, ledger.md, decisions.md, future-work.md

After creation, populate the AGENTS.md based on the user's feature request:

- **Overview**: what the user asked for (from conversation context)
- **Key Files**: initial guesses based on the feature scope
- **Quick Start**: first steps for implementation
- **Conventions**: leave as placeholder if none are known yet

### /spec status

Run: `scripts/status.sh "$PWD"`

Shows a table of all specs with their phase, blocked status, and next task.

### /spec (no args)

Same as `/spec status`.
