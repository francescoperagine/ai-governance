#!/usr/bin/env bash
# docs-check.sh — fail if a markdown doc references a repo path that doesn't exist.
# Catches link rot: a CHANGELOG pointing at a file that moved into docs/archive/
# misleads every future session, silently and forever.
# See ai_governance_template.md §9.
set -uo pipefail

cd "${1:-.}"
rc=0

while IFS=: read -r file _ ref; do
  ref="${ref%\`*}"
  [[ -e "$ref" ]] || { echo "BROKEN: $file → $ref"; rc=1; }
done < <(grep -rnoE '`(docs|src|features|tools)/[A-Za-z0-9._/-]+`' --include='*.md' . \
         | grep -v node_modules | tr -d '`')

[[ $rc -eq 0 ]] && echo "docs ok"
exit $rc
