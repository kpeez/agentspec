#!/usr/bin/env bash
set -euo pipefail

# usage: status.sh [directory]
# shows status of all specs in <directory>/specs/
# defaults to current working directory

TARGET_DIR="${1:-.}"
cd "$TARGET_DIR" || exit 1

if [[ ! -d "specs" ]]; then
    echo "No specs/ directory found."
    echo "Run: /spec new <name>"
    exit 0
fi

SPECS=$(find specs -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)

if [[ -z "$SPECS" ]]; then
    echo "No specs found in specs/"
    echo "Run: /spec new <name>"
    exit 0
fi

printf "%-20s %-12s %-8s %s\n" "SPEC" "PHASE" "BLOCKED" "NEXT"
printf "%-20s %-12s %-8s %s\n" "----" "-----" "-------" "----"

for spec_dir in $SPECS; do
    name=$(basename "$spec_dir")
    ledger="$spec_dir/ledger.md"

    if [[ ! -f "$ledger" ]]; then
        printf "%-20s %-12s %-8s %s\n" "$name" "?" "?" "(no ledger.md)"
        continue
    fi

    # extract phase (use command to bypass aliases like grep->rg)
    phase=$(command grep -E '^\s*-\s*\*\*Phase\*\*:' "$ledger" 2>/dev/null | sed 's/.*: *//' | head -1)
    phase=${phase:-"?"}

    # extract blocked status
    blocked=$(command grep -E '^\s*-\s*\*\*Blocked\*\*:' "$ledger" 2>/dev/null | sed 's/.*: *//' | head -1)
    blocked=${blocked:-"?"}

    # extract first unchecked item from Next section
    # use sed to extract lines between ## Next and the next ## heading
    next=$(sed -n '/^## Next$/,/^## /{/^## Next$/d;/^## /d;p;}' "$ledger" 2>/dev/null | command grep -E '^\s*-\s*\[\s*\]' | head -1 | sed 's/.*\] *//')
    next=${next:-"(none)"}
    # truncate if too long
    if [[ ${#next} -gt 40 ]]; then
        next="${next:0:37}..."
    fi

    printf "%-20s %-12s %-8s %s\n" "$name" "$phase" "$blocked" "$next"
done
