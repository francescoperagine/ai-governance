#!/usr/bin/env bash
# scaffold.sh — create the governance structure if absent. Never overwrites.
# Idempotent: safe to run against a repo that is already partly set up.
# See ai_governance_template.md §9.
set -euo pipefail

cd "${1:-.}"

mkdir -p docs/adr docs/archive/features features

[[ -f AGENTS.md ]]            || echo "# AGENTS.md — Operational Bootstrap" > AGENTS.md
[[ -f CHANGELOG.md ]]         || printf '# Changelog\n\nIncrements are recorded here, newest first.\n' > CHANGELOG.md
[[ -f docs/ARCHITECTURE.md ]] || echo "# Architecture" > docs/ARCHITECTURE.md
[[ -f docs/PROJECT.md ]]      || echo "# Project"      > docs/PROJECT.md
[[ -f docs/ROADMAP.md ]]      || echo "# Roadmap"      > docs/ROADMAP.md
[[ -f docs/todo.md ]]         || echo "# Todo (maintainer only)" > docs/todo.md

echo "scaffold ok — $(pwd)"
echo "next: fill AGENTS.md from the template (§8), then write ARCHITECTURE.md once code exists"
