#!/usr/bin/env bash
# docs-check.sh — fail if a markdown doc references a repo path that doesn't exist.
# Catches link rot: a CHANGELOG pointing at a file that moved into docs/archive/
# misleads every future session, silently and forever.
# See ai_governance_template.md §9.
set -uo pipefail

cd "${1:-.}"
rc=0

# Append-only historical records are EXCLUDED by design. A CHANGELOG entry, an ADR, or an
# archived SPEC is supposed to name paths that no longer exist — that is what history is.
# Retiring a feature (§4 Phase 4) deletes its folder, and every past reference to it would
# otherwise be reported as rot forever. Only documents that claim to describe the present
# are checked.
# ai_governance_template.md is excluded for the same reason: it is the manual, and it names
# paths (docs/PROJECT.md, features/<name>/SPEC.md) that exist in adopting projects, not here.
EXCLUDE='node_modules|/\.|/docs/archive/|/docs/adr/|/CHANGELOG\.md|ai_governance_template\.md'

while IFS=: read -r file _ ref; do
  ref="${ref%\`*}"
  [[ -e "$ref" ]] || { echo "BROKEN: $file → $ref"; rc=1; }
done < <(grep -rnoE '`(docs|src|features|tools)/[A-Za-z0-9._/-]+`' --include='*.md' . \
         | grep -vE "$EXCLUDE" | tr -d '`')

[[ $rc -eq 0 ]] && echo "docs ok"
exit $rc
