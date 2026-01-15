#!/usr/bin/env bash
set -euo pipefail

# usage: create-spec.sh <name>
# creates specs/<name>/ with standard template files

if [[ $# -lt 1 ]]; then
    echo "Usage: create-spec.sh <name>"
    exit 1
fi

RAW_NAME="$1"
# slugify: lowercase, replace spaces with hyphens
NAME=$(echo "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
# title case for display
TITLE=$(echo "$RAW_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

SPEC_DIR="specs/$NAME"

if [[ -d "$SPEC_DIR" ]]; then
    echo "Error: $SPEC_DIR already exists"
    exit 1
fi

mkdir -p "$SPEC_DIR"

# AGENTS.md
cat > "$SPEC_DIR/AGENTS.md" << EOF
# $TITLE - Agent Instructions

Read this file first when working on this feature.

## Overview
<!-- 1-2 sentences: what we're building and why -->

## Key Files
<!-- update as you work. format: \`path/to/file.ts\` - purpose -->

## Conventions
<!-- feature-specific patterns, constraints, or gotchas -->

## Quick Start
<!-- for a new agent: what to read first, what to do first -->
EOF

# design.md
cat > "$SPEC_DIR/design.md" << EOF
# $TITLE - Design

## Overview
(brief technical approach - fill in during design phase)

## Key Components
(to be defined)

## Data Flow
(to be defined)
EOF

# ledger.md
cat > "$SPEC_DIR/ledger.md" << EOF
# $TITLE - Ledger

## Status
- **Phase**: design
- **Blocked**: no

## Done
(nothing yet)

## Next
- [ ] Define the technical approach

## Context
(gotchas, non-obvious things discovered)
EOF

# decisions.md
cat > "$SPEC_DIR/decisions.md" << EOF
# $TITLE - Decisions

Log non-obvious technical choices here.

---

(No decisions recorded yet)
EOF

# future-work.md
cat > "$SPEC_DIR/future-work.md" << EOF
# $TITLE - Future Work

Ideas and improvements deferred for later.

(Nothing yet)
EOF

echo "Created $SPEC_DIR/"
echo "  - AGENTS.md"
echo "  - design.md"
echo "  - ledger.md"
echo "  - decisions.md"
echo "  - future-work.md"
