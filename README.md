# ai-governance

A stack-agnostic, tool-agnostic system for running AI-assisted software projects: how work is
tiered, where knowledge lives, how sessions hand off to each other on disk, and how the whole
thing is optionally automated.

**[`ai_governance_template.md`](ai_governance_template.md) is the whole system.** The two
scripts are extracted from its §9 so they don't have to be copy-pasted per project.

[`ai_governance_rationale.md`](ai_governance_rationale.md) holds the optional automation
(§11–§12), the note on context-compression proxies (§13), and the design rationale (§15).
Adopting projects never read it. It is separate so that revising it — reference implementations
age, cached vendor facts age faster — does not bump the template's version.

## Use it

Hand `ai_governance_template.md` to an agent in the target project, with no other instruction.
It carries a directive block that tells the agent to adopt the system, in plan mode, without
touching source code. If you give it an instruction alongside the file, yours wins.

To upgrade a project that already adopted an earlier version: same file, same non-instruction.
It detects the `Governance: ai-governance-template v<N>` line in the project's `AGENTS.md` and
runs as an upgrade instead.

## Scripts

```
./scaffold.sh   [path]   # create missing governance files; never overwrites
./docs-check.sh [path]   # fail on markdown references to paths that don't exist
```

Wire `docs-check.sh` into the project's task runner as `docs:check`.

## Versioning

A monotonic integer at the top of the template. Bump it only when a change would require an
existing project to do something — not for wording, rationale, or facts about third-party
tools. Git history is the changelog.

A project at v1 while the template is at v3 is not in debt. It is a project whose conventions
have been stable for two revisions.

## Scope

Deliberately five files. No CI, no tests, no generator CLI. The failure mode for a personal
governance system is not being too small — it is becoming a product.
