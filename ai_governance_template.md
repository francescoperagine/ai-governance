# AI Project Governance — Template

**Template version: 3**

> Monotonic integer, same reasoning as `INC-XXX` (§5): no semver, because there is no
> dependency to resolve and no "is this a minor?" to argue about. Bump it when a change would
> require an existing project to do something. Don't bump it for wording, rationale, or facts
> about third-party tools. The git history of this file is its changelog.
>
> An adopting project records the version it was generated from in its `AGENTS.md`. That single
> line is what makes an upgrade diffable instead of archaeological.

> ## ▶ IF YOU ARE AN AI AGENT AND THIS FILE WAS HANDED TO YOU
>
> **Precedence.** If the user gave you an explicit instruction alongside this file — review it,
> critique it, answer a question about it, apply one part of it — **that instruction wins and
> this block does not apply.** Do that, not this.
>
> **Default, when no other instruction was given:** you have been asked to *adopt this system
> for this repository*. Execute the adoption handoff in §0. It is your task, not an example —
> the fence around it is formatting, nothing more.
>
> **MODE: PLAN. Do not modify any file under `src/` (or this project's source directory).**
> Adoption creates and edits documentation only. If you conclude that implementation should
> begin, say so and stop.
>
> **Read in this order — not the whole file:** §0 (your task) → §2 (work tiers) → §4–§5
> (lifecycle, increments) → §8 (the `AGENTS.md` template you will fill in) → §9 (scaffolding).
> Optional automation and the system's own rationale live in a separate file,
> `ai_governance_rationale.md` — do not open it unless the user asked for automation.
>
> **Anything you cannot determine from the repo** — project identity, output language,
> long-term direction — becomes a `TODO(human):` marker, never a guess. Collect every open
> question into **one** block at the end of your report. Do not ask them one at a time.

> **What this is.** A stack-agnostic, tool-agnostic system for running AI-assisted software
> projects: how work is tiered, where knowledge lives, how sessions hand off to each other,
> and how the whole thing is optionally automated.
>
> **This file is the manual, not a file you copy into a project.** It describes the system and
> contains the templates you instantiate. **§0 is how to put it to work** — including a
> paste-ready handoff that has an agent adopt the system for you. §1–§10 are the system itself
> (manual operation, any tool). Optional automation — which needs headless invocation or
> subagent spawning — and the design rationale behind all of this are in the companion file
> `ai_governance_rationale.md`. Adopting projects never need it.
>
> **Design constraint: nothing here may depend on a specific vendor, model, or subscription
> tier.** Where a vendor is named it is a reference implementation, clearly marked as such.

---

## 0. How To Use This Document

Three ways in, in increasing order of effort.

**Read it yourself** if you want to understand the system: §1–§5 is the whole thing. §6 is the
mechanism that makes multi-session work reliable. `ai_governance_rationale.md` is optional and
can wait forever.

**Hand it to an agent** to set a project up: paste the adoption handoff below into a fresh
session, with this file present in or next to the repo. It is written in the same shape the
system uses for everything else — a self-contained `mode: plan` handoff — so adopting the
system is itself an instance of the system.

**Run one increment** to try it: pick the next thing you were going to build anyway, run the
adoption handoff, then follow §4 Phase 1 → Phase 2 once. One feature is enough to tell whether
the ceremony is paying for itself at your project's scale.

### Upgrading a project that already adopted an earlier version

**Same handoff.** It detects an existing `Governance: ... v<N>` line in `AGENTS.md` and runs as
an upgrade instead of an adoption. There is no separate migration procedure, because there is
no dependency to resolve: this is a scaffold, and its output forked when it was generated.

What an upgrade may and may not touch:

| | |
|---|---|
| **Rewrite freely** | The behavioral-rules block (§7) and the work-tier definitions — they are verbatim template text. |
| **Migrate, reporting each change** | Structural differences: renamed files, new directories, new front-matter fields. |
| **Never touch** | Stack, commands, invariants, localization, anything under `## Project Deviations`, and all existing history. |
| **Ignore entirely** | `ai_governance_rationale.md`. Projects don't consume the template's own rationale. |

If the version line is absent, the project predates versioning: treat it as an adoption that
must not overwrite, and report the delta instead of applying it.

**Upgrade only when a change would actually change your behavior.** A project running v1 while
the template sits at v3 is not in debt — it is a project whose conventions have been stable
for two revisions. Chasing the version number is ceremony, and this system already spent its
ceremony budget in §2.

### Adoption handoff

> Paste it into a fresh session, or — if you are the agent that was handed this file with no
> other instruction — **this is your task**. The code fence marks its boundaries so it can be
> copied verbatim; it does not make it hypothetical.

```markdown
---
mode: plan
feature: governance-adoption
phase: A — assess and scaffold
inc_base: <INC at CHANGELOG head, or 000 if no CHANGELOG exists>
files_in_scope:
  - NEW: AGENTS.md
  - NEW: CHANGELOG.md
  - NEW: docs/ARCHITECTURE.md
  - NEW: docs/PROJECT.md
  - NEW: docs/ROADMAP.md
gate_commands:
  - <the project's build command, or "none — no code touched">
stop_conditions:
  - Repo already has a conflicting governance system with different file names
  - More than 3 stale feature folders found (needs a human decision on each)
---

> **MODE: PLAN — assess, scaffold, and document. Do NOT modify any file under `src/`.
> If you believe implementation should start now, say so and stop.**

## Reading Order
1. `<path>/ai_governance_template.md` — the system being adopted. Read §2–§9 fully.
2. The repo root and `docs/` — what already exists.
3. `README.md` and `package.json` (or equivalent) — stack, commands, project identity.

## Context
This repo is adopting the governance system described in the template. It may be a new
project, or an existing one with partial or ad-hoc conventions already in place. Adopt, do
not restart: existing history is authoritative.

## Scope

Deliverables:
1. **Assessment.** Which governance files already exist, which are missing, and which exist
   under a different name. Report before changing anything.
2. **Scaffolding.** Create only what's missing, per §9. Never overwrite an existing file.
3. **`AGENTS.md`.** Fill the §8 template with this project's real specifics: stack, build and
   test commands, core invariants inferred from the code, output language. Decide where the
   behavioral rules live (§7) — this tool's system-prompt mechanism if it has one, otherwise
   inline — and put a pointer in the other place. Never both.
   Record the template version in the `Governance: ai-governance-template v<N>` line, and keep
   the `## Project Deviations` section (empty is fine — it is where an upgrade looks first).

   **If that line already exists, this is an upgrade, not an adoption.** Rewrite only the
   behavioral-rules block and the tier definitions, migrate structural changes while reporting
   each one, and leave stack, commands, invariants, localization, listed deviations, and all
   history untouched. Report the delta before applying anything that isn't verbatim template
   text.
4. **Existing-state migration**, if the repo has history:
   - Feature folders whose work already shipped → retire per §4 Phase 4
     (`docs/archive/features/INC-<closing>_<name>.md`, delete the folder).
   - Feature folders whose status is unclear → list them, do not touch them, escalate.
   - Do NOT retrofit ADRs onto past increments. Conditional ADRs (§5) apply going forward.
5. **`docs:check`.** Add the script from §9 and wire it into the task runner. Report broken
   references found; fix only unambiguous ones.
6. **First increment entry.** Record this adoption in `CHANGELOG.md` as the next `INC-XXX`
   (or `INC-001` if new), with `ADR: none (mechanical)` unless a real choice was made — e.g.
   choosing to drop `docs/archive/` in favor of git, which is an ADR.

Explicitly out of scope:
- Any change to source code, build config, or dependencies.
- Rewriting existing `CHANGELOG.md` history or renumbering increments.
- Creating feature folders for work that isn't starting now.

## Constraints
- **Code wins over docs.** Verify every path against the real repo before writing it into a
  document. Do not document a structure you have not confirmed exists.
- Tier the adoption itself: this is one Small increment unless the migration in (4) turns out
  to be substantial.
- Do not invent project identity, vision, personas, or roadmap. If `docs/PROJECT.md` or
  `docs/ROADMAP.md` can't be written from evidence in the repo, leave a stub with explicit
  `TODO(human):` markers and say so.
- **Output language:** infer it from existing docs, comments, and UI strings. If the repo is
  mixed or silent, leave `[your language]` as a `TODO(human):` — do not default to English
  because the template is in English.
- Gate commands must be **read from the task runner**, not assumed. If no build or test
  command exists, write `none` and flag it.

## Handoff
None — this closes the adoption.

Report, in this order: what was created · what was migrated · what was left alone and why ·
**one consolidated block of every open question and `TODO(human):` marker**. Ask nothing
before that block; ask everything in it. The next feature follows §4 Phase 1 normally.
```

---

## 1. Why This System Exists

AI coding agents are context-hungry. Every session burns tokens re-learning conventions, stack,
file locations, and "how we do things here." Without a system you repeat yourself, the agent
makes avoidable mistakes, and planning evaporates into chat history.

**The solution in one sentence:** every file answers exactly one question, work is tiered so
ceremony matches stakes, and the disk — not the conversation — is the persistence layer between
sessions.

### Core Principles

| Principle | What it means |
|---|---|
| **AI-first, human-auditable** | Structured for machine scanning (deterministic paths, fixed sections) but readable by a human. |
| **One question, one file** | `AGENTS.md` = how to work. `ARCHITECTURE.md` = what the system is. `PROJECT.md` = where it's going. No file answers two questions. |
| **Disk as persistence** | Nothing load-bearing lives only in chat or in agent memory. A fresh session with zero history must be able to continue. |
| **Ceremony proportional to stakes** | A typo, a small fix, and a feature are three different things with three different overheads. See §2. |
| **Rules must match reality** | A mandatory rule that is disobeyed half the time is a broken rule, not a discipline problem. Fix the rule. |
| **Compression without loss** | Every rule exists in exactly one canonical place. If it's in a linked file, don't restate it inline. |
| **Don't restate what a tool enforces** | If a linter, formatter, type checker, hook, or CI gate already enforces a constraint deterministically, writing it into `AGENTS.md` buys nothing and costs tokens on every turn. Prose is for what no tool can check. |
| **External facts are cached, dated, subordinate** | Third-party tool behavior changes faster than this document. Record it anyway — re-exploring vendor docs every session costs more than a stale line, and web access isn't always available. But stamp it with a date, name the source, and state that the live docs win on conflict. Same shape as *code wins over docs*, one level out. |

---

## 2. Work Tiers (read this before anything else)

Most of the overhead in a governance system comes from applying feature-grade ceremony to
non-feature-grade work. Three tiers:

| Tier | What qualifies | Required artifacts |
|---|---|---|
| **Trivial** | Typo, comment, formatting, one-liner with no behavior change | Nothing. Just do it. |
| **Small** | Localized change with behavior: a bugfix, a copy change, a dependency bump, a contained refactor. Fits in one session, no design decision with real alternatives. | One `CHANGELOG.md` entry (`INC-XXX`). No feature folder, no SPEC, no ADR. |
| **Feature** | Multi-increment work, or any change that alters architecture, contracts, schemas, or public behavior. | Full lifecycle: `features/<name>/`, `SPEC.md`, handoff files, `CHANGELOG.md` per increment, ADR where a decision was made (§5). |

**Deciding.** If you are unsure between Small and Feature, ask: *does this need more than one
session, or did I choose between real alternatives?* Either yes → Feature.

### The tier also caps what gets read

Artifacts produced are only half of it. The recurring cost of a governance system is what the
agent *reads* before it starts, on every task, forever — so the tier gates that too:

| Tier | Reads before starting |
|---|---|
| **Trivial** | Nothing. Open the file and fix it. |
| **Small** | `AGENTS.md`, plus the files being changed. Not the architecture, not the roadmap. |
| **Feature** | The full reading order — `AGENTS.md` → `ARCHITECTURE.md` → `PROJECT.md` — plus the feature's `SPEC.md`. |

An unconditional reading order costs several hundred lines of context on every task, most of
them irrelevant to a two-line fix. `CHANGELOG.md`, `docs/adr/`, and `docs/archive/` are never
read wholesale at any tier: query them for the one entry you need.

**Rationale.** The previous version of this system defined non-trivial as "anything beyond a
typo", which meant a 20-line bugfix earned a folder, a SPEC, a PROMPT, and an ADR. In practice
the ceremony got skipped — including on the work that actually needed it. Tiering restores the
authority of the Feature tier by not spending it on everything.

---

## 3. The Documentation Core

```
project-root/
├── AGENTS.md                     # Operational bootstrap for the AI agent
├── CHANGELOG.md                  # Increment history (INC-XXX)
├── docs/
│   ├── ARCHITECTURE.md           # Current system topology, glossary, responsibilities
│   ├── PROJECT.md                # Identity, vision, personas, constraints, current focus
│   ├── ROADMAP.md                # Long-term direction, milestones
│   ├── adr/ADR-NNN-<slug>.md     # Architecture Decision Records
│   ├── archive/
│   │   └── features/
│   │       └── INC-<closing>_<feature-name>.md   # Retired SPECs (§4, Phase 4)
│   └── todo.md                   # Maintainer's personal backlog — agent must not touch
└── features/
    └── <feature-name>/           # ONLY in-progress work. Empty is the healthy state.
        ├── SPEC.md               # Live ledger: scope, decisions, acceptance criteria
        └── PROMPT.md | HANDOFF.md  # Entry point for the next session
```

### Who answers what

| Question | File |
|---|---|
| How do I work in this repo? | `AGENTS.md` |
| What does the system look like right now? | `docs/ARCHITECTURE.md` |
| What is this project, who is it for, what constrains it? | `docs/PROJECT.md` |
| Where is it going long-term? | `docs/ROADMAP.md` |
| What changed, in what order? | `CHANGELOG.md` |
| Why was this decision made? | `docs/adr/ADR-NNN-*.md` |
| What's the status of feature X? | `features/<name>/SPEC.md` |
| What did feature X decide, after it shipped? | its ADR — and `docs/archive/features/` for the full ledger |
| What's the maintainer's backlog? | `docs/todo.md` |

**Conflict resolution:** when docs and code disagree, **code wins**. Documentation is a map,
not the territory. Verify paths against the real repo before trusting a document.

**`features/` is a working area, not a museum.** A folder in `features/` asserts "work in
progress". If the work shipped, the folder must be gone (§4, Phase 4). A stale folder is worse
than no folder: it tells the next session that unfinished work exists when it doesn't.

---

## 4. The Feature Lifecycle

### Phase 1 — Plan (reasoning session)

```
1. Read AGENTS.md → docs/ARCHITECTURE.md → docs/PROJECT.md
2. Interrogate the request before scoping it — unstated assumptions, missing constraints,
   what "done" means, what is deliberately out. One batch (§7 rule 2), answers into the SPEC.
   A spec written from an unexamined request specifies the wrong thing precisely.
3. Create features/<feature-name>/   (kebab-case)
4. Write SPEC.md — scope, decisions, acceptance criteria, phase ledger
5. Write PROMPT.md — self-contained entry point, mode: implement
6. Self-conclude: deliver SPEC.md + PROMPT.md. Do NOT start implementing.
```

### Phase 2 — Implement (fresh session)

```
1. Clear context / start a new session
2. Submit features/<feature-name>/PROMPT.md
3. Verify the handoff against the real repo (paths, inc_base) — discrepancy = stop and report
4. Implement exactly the increment in scope
5. Run the gate; record commands and exit codes verbatim
6. Update CHANGELOG.md (INC-XXX read from CHANGELOG head)
7. Create/update ADR — only if a decision with alternatives was made (§5)
8. Update SPEC.md (mark phase done)
9. If work remains: write HANDOFF.md. Else: proceed to Phase 4.
10. Self-conclude with a short report
```

### Phase 3 — Continue

Same as Phase 2, with `HANDOFF.md` as the entry point. Repeat until the SPEC ledger is empty.

### Phase 4 — Retire (part of the last increment, not a separate chore)

Closing a feature is a step of the final increment's completion checklist, not an optional
tidy-up afterwards. A feature is not complete until:

1. `features/<name>/SPEC.md` is moved to
   `docs/archive/features/INC-<closing-increment>_<feature-name>.md`
   — e.g. `docs/archive/features/INC-128_campaign-view-panel-contract.md`.
2. `features/<name>/` is deleted, including any handoff files.
3. `docs/PROJECT.md` is updated (feature no longer active).
4. `docs/ROADMAP.md` is updated if the feature closed a milestone.

**Why a single flat file with an INC prefix:** every archived SPEC gets a globally unique,
sortable, self-describing name. `@`-style file pickers and greps show
`INC-128_campaign-view-panel-contract.md` — unambiguous — instead of a wall of identical
`SPEC.md` entries. The closing increment number also dates the artifact without a date.

**Why archive at all, given git keeps everything:** the ADR holds the *decisions*; the archived
SPEC holds the *ledger* — what was in scope, what was deliberately excluded, what was deferred.
That is the part people actually re-read six months later, and grepping a directory beats
archaeology through git history. If you find you never open `docs/archive/features/`, delete
the directory and let git be the archive — but decide, don't drift.

### SPEC.md template

```markdown
# SPEC — <Feature Name>

**Status:** DRAFT | IN PROGRESS | COMPLETE

## Problem
_(What problem does this solve? One paragraph.)_

## Scope
_(In / out. Explicit boundaries.)_

## Design Decisions
_(Key choices with rationale. Each one that had real alternatives becomes an ADR.)_

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Constraints
- _(Hard constraints from PROJECT.md or architectural invariants.)_

## Phase Ledger
| Phase | Increment | Status | Notes |
|---|---|---|---|
| A — <name> | — | TODO | |
| B — <name> | — | TODO | |

## Open Items
- _(Known gaps, deferred decisions, follow-ups.)_
```

---

## 5. The Increment Protocol

Every shipped piece of Small- or Feature-tier work is an **increment** with a unique ID.

1. **The ID is auto-assigned.** Read the head of `CHANGELOG.md` (e.g. `INC-120`) and use the
   next number. Never hand-assign, never skip.

2. **Every increment appears in `CHANGELOG.md`** with: ID, date, summary (what + why),
   deliverables, gate status (commands run + result).

3. **ADR when — and only when — a decision was made.** An ADR is required if the increment
   chose between real alternatives with a lasting consequence: architecture, contract, schema,
   dependency, or a convention future work must follow. Mechanical increments (implementing an
   already-decided spec, fixing a bug, applying a rename) get `ADR: none (mechanical)` or a
   reference to the ADR they execute.
   *An ADR that reads "we did the thing we said we'd do" is noise. Do not write it.*

4. **Cross-reference both directions.** Every ADR names its originating increment; every
   increment that has an ADR names it.

### CHANGELOG entry format

```markdown
## INC-XXX

Date: YYYY-MM-DD

Summary:
**<One-line title>.**
_(One paragraph: what and why.)_

Deliverables:
- _(Concrete, verifiable item.)_

ADR: ADR-NNN (<status>) | none (mechanical). Gate: (<commands> — <result>).
```

### ADR format

```markdown
# ADR-NNN — <Title>

Status: Proposed | Accepted | Superseded
Increment: INC-XXX

## Context
_(What is the problem? What constrains the solution?)_

## Decision
_(What was chosen. Be specific — key design choices, not just the option name.)_

## Consequences
_(Trade-offs. What gets easier, what gets harder.)_

## Alternatives Considered
- **Option A:** _(What, why rejected.)_
- **Option B:** _(What, why rejected.)_
```

---

## 6. The Handoff Contract

A handoff file (`PROMPT.md` / `HANDOFF.md`) is the bridge between two sessions that share no
conversation history. It must be readable and executable with **zero** context carry-over.

### Front-matter (machine-checkable)

```yaml
---
mode: plan | implement
feature: <kebab-case-name>
phase: <phase id from the SPEC ledger>
inc_base: <INC number at CHANGELOG head when this file was written>
files_in_scope:
  - <repo-relative path>          # prefix with NEW: for files to be created
gate_commands:
  - <exact command; exit 0 means pass>
stop_conditions:
  - <condition that must abort and escalate to the human>
---
```

### `mode` is not decoration — it is the fix for the most common failure

The single most frequent failure of this workflow is: the human clears context, submits a file
meant to produce a plan, and the agent starts writing code instead. The cause is that a handoff
file does not state its own role, so the agent infers it from the content — and content that
describes an implementation reads like an instruction to implement.

**Therefore every handoff file opens with an explicit role banner, above everything else:**

```markdown
> **MODE: PLAN — produce SPEC.md and a handoff file. Do NOT modify any file under `src/`.
> If you believe implementation should start now, say so and stop.**
```

or

```markdown
> **MODE: IMPLEMENT — execute the scope below. Do NOT redesign, do NOT expand scope.
> If the spec is ambiguous or contradicts the repo, stop and report before writing code.**
```

`AGENTS.md` carries the matching rule, so the constraint holds even if the banner is skimmed:
*"When the entry file declares `mode: plan`, writing to source files is a violation, not a
shortcut."* Two enforcement points — front-matter and prose — because one is regularly missed.

### Handoff body template

```markdown
# <PROMPT|HANDOFF> — <Task Description>

> **MODE: <PLAN|IMPLEMENT> — <the matching banner from above>**
>
> Run this in a fresh session. Everything needed is in this file or the files it names.

## Reading Order
1. `AGENTS.md` — working conventions
2. `features/<feature-name>/SPEC.md` — authoritative scope
3. _(Any ADR or file that must be read before starting.)_

## Context
_(What is already done, what this increment builds on. Brief.)_

## Scope
Deliverables:
1. _(Concrete, verifiable item.)_
2. _(Concrete, verifiable item.)_

Explicitly out of scope:
- _(What NOT to touch.)_

## Constraints
- _(Invariants, files not to touch, tests that must stay green.)_
- Gate: _(exact commands — same as front-matter `gate_commands`.)_

## Handoff
_(What the next handoff should scope, if work remains. "None — this closes the feature"
if it doesn't, and then Phase 4 applies.)_
```

### Validation rules (mechanical — no model judgment)

Before a handoff is executed — by a human glance or by a script
(`ai_governance_rationale.md` §11):

- All front-matter keys present; `feature` matches the directory name.
- Every path in `files_in_scope` exists, or is marked `NEW:`.
- `inc_base` equals the actual CHANGELOG head. A mismatch means a previous session crashed
  between implementing and documenting, or two chains ran concurrently. **Stop.**
- On any failure: stop and report. **Never repair a handoff automatically** — a malformed
  handoff is a signal that the previous session's model of the repo was wrong.

---

## 7. Agent Behavioral Rules (canonical text)

> These are behavioral meta-rules: they modify *how* the agent operates, not *what* it knows.
> **This section is the single canonical copy.** Everything else in this document references
> it. Do not duplicate it — including into the AGENTS.md template in §8.

1. **No tests or builds when live code wasn't touched.** Doc-only, spec-only, and planning
   turns must not run test suites, typechecks, or builds "just in case". When live code IS
   touched, prefer targeted tests over the full suite; run the full gate at explicit
   checkpoints or on request.

2. **Batch doubts and criticalities.** Collect all questions, risks, and decision points and
   present them together in one message — never one question at a time across turns.

3. **Tasks are self-concluding.** A turn ends with a complete deliverable, not an open
   conversation. No "shall I proceed?". Offering a follow-up after finished work is fine;
   blocking on it is not.

4. **Task tiering (plan / implement / verify).**
   - High-capability reasoning models own design work: understanding, architecture, planning,
     specification, verification, and durable documentation.
   - Implementation workers own deterministic execution of an approved specification.
   - A worker must never receive an incomplete design problem. A spec must be complete enough
     that implementation is mechanical.
   - Choose an execution strategy — `DIRECT`, `SINGLE_WORKER`, `MULTI_WORKER` — based on
     remaining *decision* complexity, not implementation size.
   - Delegate whenever implementation is primarily mechanical, regardless of size: preserving
     reasoning context is worth more than minimizing total tokens.
   - **Preferred flow: several short reasoning sessions connected by documents**, rather than
     one long reasoning session.

5. **Split tasks to cap context growth.** Planning session writes `SPEC.md` + handoff →
   fresh session executes the handoff. Handoff files must be self-contained: repo-relative
   paths, conventions, constraints, acceptance criteria. Zero dependency on conversation
   history.

6. **Context hygiene.** Read only the line ranges needed. Don't re-read what's already in
   context. Use search or a delegated explorer for broad sweeps instead of dumping files into
   the main context. Keep status updates and summaries lean — decisions and outcomes, not
   narration.
   **Get a fact by running the command that prints it, not by reading the file that holds it.**
   The next increment number is `grep -m1 '^## INC-' CHANGELOG.md`, not a read of a
   four-thousand-line changelog. The same goes for the branch, the changed files, whether a
   path exists. A command returns the exact fact for a handful of tokens; a file read returns
   the fact plus everything around it, forever, in context.

7. **Verify, don't trust.** A subordinate's report that the gate passed is not evidence.
   Re-run the gate; the exit code decides. Read the diff of what a worker changed before
   documenting it as done.

8. **Simplest thing that works.** Prefer what already exists — the standard library, a native
   platform feature, an installed dependency, a helper already in this repo — over new code,
   and new code over a new dependency. No abstraction with one implementation, no configuration
   for a value that never changes, no scaffolding for a requirement nobody has stated. Tests
   follow the same rule: non-trivial logic leaves one runnable check behind, not a suite.
   A deliberate shortcut is fine when a comment names its ceiling; an unrequested
   generalization is not.

### Where to put these rules

**Best: the system prompt.** If the tool supports behavioral instructions injected at the
system level — output styles, `.cursorrules`, a custom system-prompt field, a persona file —
put them there. They are read once per session and cached, never reprocessed per turn.

**Fallback: a section in `AGENTS.md`.** Every AI coding tool reads `AGENTS.md` (or its
equivalent) as project context, so this works everywhere. The cost is re-reading them as part
of project context each turn.

**Never both.** Duplicating them costs tokens on every turn and creates two things to keep in
sync. Pick one home; put a one-line pointer in the other place.

**Never bake the mechanism into the template.** A vendor-specific path
(`.claude/output-styles/`, a particular config filename) hard-coded into a reusable governance
document breaks the moment you use a different tool. *Where* the rules live is a per-project
decision made at setup time; only the rules themselves are portable.

---

## 8. AGENTS.md Template

Operational bootstrap. Defines *how* to work, not *what* the system is.

> **Keep it short — this is measured, not aesthetic.** Published evaluations of agent context
> files report that long, autogenerated, or redundant `AGENTS.md` files *degrade* performance:
> in 5 of 8 tested settings they lowered task success, added roughly 2.5–4 steps per task, and
> raised inference cost 20–23%. A context file is not free documentation; it is a tax paid on
> every turn.
>
> Two filters before any line goes in:
> 1. **Does a tool already enforce this?** Linter, formatter, type checker, hook, CI gate — if
>    yes, delete the line. The gate will say it better and at the right moment.
> 2. **Is this discoverable in seconds?** Script names in `package.json`, the directory layout,
>    the framework in use — the agent can read those. Write down only what it cannot infer:
>    invariants, conventions, and the reasoning behind non-obvious choices.
>
> **Give it a budget and treat overruns as defects.** ~120 lines is a workable ceiling for a
> single-project repo. This is the only file in the system with a *recurring* cost — everything
> else (CHANGELOG entries, ADRs, SPECs) is written once and read on demand. Optimizing what you
> record is mostly wasted effort; optimizing what gets read on every turn is where the spend
> actually is.
>
> The template below is deliberately at the short end. Cut further if your project allows;
> resist growing it.

```markdown
# AGENTS.md — Operational Bootstrap

You are an expert **[stack]** engineer maintaining **[project description]**.

**This file is operational, not informational.** *What the system is* →
`docs/ARCHITECTURE.md`; *where it's going* → `docs/PROJECT.md`.
**Single source of truth = the code in `src/`. On any docs↔code conflict, `src/` wins.**

<!-- Governance: ai-governance-template v<N>. Deviations from the template below this line are
     deliberate and project-specific — an upgrade must preserve them. -->

## Project Deviations

_Anything this project does differently from the template, and why. An upgrade reads this
section first and must not undo what it lists. Empty is a valid value._

- _(e.g. "No `docs/archive/` — git is the archive. See ADR-004.")_

## Behavioral Rules (MANDATORY — read first)

[EITHER paste the eight rules from §7 of the governance template here,
 OR — if this tool supports system-level instructions — replace this section with:]

> Operate per the behavioral rules in `[.cursorrules | output style | system prompt]`.
> They are the lens through which every rule below is interpreted. Do not skip them.

## Work Tiers

- **Trivial** (typo, comment, one-liner, no behavior change): just do it, no artifacts.
- **Small** (contained change with behavior, one session, no real alternatives):
  one `CHANGELOG.md` entry. No feature folder, no SPEC, no ADR.
- **Feature** (multi-increment, or touches architecture/contracts/schemas/public behavior):
  full lifecycle below.

## Reading Order

1. `AGENTS.md` — this file.
2. `docs/ARCHITECTURE.md` — current system state.
3. `docs/PROJECT.md` — current focus + active features.

`CHANGELOG.md` only when recent history matters. `features/<name>/SPEC.md` only when the task
touches that feature.

## Core Invariants

_The architectural rules no tool in this repo can check. Nothing the linter or type checker
already catches. Two to five lines. Example of the right altitude:_

- **Data separation.** Rules and constants live in the data layer, never in components.

## Handoff Mode Discipline

Handoff files declare `mode:` in front-matter and repeat it as a banner on line 1.

- `mode: plan` → produce `SPEC.md` and the next handoff. **Writing to source files is a
  violation, not a shortcut.** If you think implementation should start, say so and stop.
- `mode: implement` → execute the listed scope. Do not redesign, do not widen scope.

Verify a handoff's paths and `inc_base` against the real repo before executing it. On any
discrepancy — or if reality contradicts the spec — **stop and report. Do not improvise.**

## Feature Lifecycle

Feature-tier work lives in `features/<name>/` (kebab-case): `SPEC.md` plus one entry-point
handoff. A planning session writes them; a fresh session executes them.

**Closing a feature is part of the last increment:** `SPEC.md` →
`docs/archive/features/INC-<closing>_<name>.md`, delete `features/<name>/`, update
`docs/PROJECT.md` (and `docs/ROADMAP.md` if a milestone closed). A folder left behind falsely
claims work is in progress.

## Task Completion (MANDATORY)

Gate: `[build command]` and `[test command]` — **only when live code was touched.** Record the
command and its exit code, never a claim that it passed.

Then, before the task counts as done:

- `CHANGELOG.md` entry with a unique `INC-XXX` read from the CHANGELOG head.
- ADR **only if a decision with real alternatives was made**; else `ADR: none (mechanical)`.
- `SPEC.md` updated; `docs/ARCHITECTURE.md` too if topology changed.
- Feature closed → retirement steps above.
- Output language: **[your language]**.

**Where knowledge goes.** Direction → `ROADMAP.md` · focus → `PROJECT.md` · decisions →
`docs/adr/` · in-progress → `features/<name>/SPEC.md` · shipped → `CHANGELOG.md` · system shape
→ `ARCHITECTURE.md` · retired SPECs → `docs/archive/features/`.
`docs/todo.md` is the maintainer's — **do not touch unless asked.**

**Self-conclude.** Gate green → checklist done → next handoff if work remains → short report →
**end. Do not ask for further instructions.**

## Project-Specific Standards

_Only what no tool enforces. Script names are in the task runner; don't list them here._

- **[the convention a reviewer keeps having to repeat]**

## Scope Discipline

Modify only files in scope, and instruct delegated workers to do the same. Verify the diff
before consolidating: an out-of-scope change is a defect even when it is an improvement.
```

---

## 9. Bootstrap & Maintenance

### Scaffolding a new (or existing) project

Idempotent — safe to run against a repo that is already partly set up. Creates only what's
missing.

```bash
#!/usr/bin/env bash
# scaffold.sh — create governance structure if absent. Never overwrites.
set -euo pipefail
mkdir -p docs/adr docs/archive/features features
[[ -f AGENTS.md ]]              || echo "# AGENTS.md — Operational Bootstrap"     > AGENTS.md
[[ -f CHANGELOG.md ]]           || printf '# Changelog\n\nIncrements are recorded here, newest first.\n' > CHANGELOG.md
[[ -f docs/ARCHITECTURE.md ]]   || echo "# Architecture"      > docs/ARCHITECTURE.md
[[ -f docs/PROJECT.md ]]        || echo "# Project"           > docs/PROJECT.md
[[ -f docs/ROADMAP.md ]]        || echo "# Roadmap"           > docs/ROADMAP.md
[[ -f docs/todo.md ]]           || echo "# Todo (maintainer only)" > docs/todo.md
echo "scaffold ok"
```

`docs/ARCHITECTURE.md` is a stub on purpose: write it **after** the first code exists, or it
documents an imagined system.

**Minimum viable setup** if you're impatient: `AGENTS.md` + `CHANGELOG.md` + `docs/adr/` +
`features/`. The rest grows organically.

### The one automation worth having: `docs:check`

Documentation link rot is invisible and compounding — a `CHANGELOG.md` pointing at a file that
moved into `docs/archive/` misleads every future session. This costs zero tokens because it is
a script, not an agent.

```bash
#!/usr/bin/env bash
# docs-check.sh — fail if a markdown doc references a repo path that doesn't exist.
set -uo pipefail
rc=0

# Append-only historical records are excluded by design: a CHANGELOG entry, an ADR, or an
# archived SPEC is SUPPOSED to name paths that no longer exist. Retirement (§4 Phase 4) deletes
# feature folders, so every past reference to them would otherwise be rot forever. Only
# documents that claim to describe the present are checked. The last entry is a no-op in an
# adopting project; it keeps this one script identical everywhere, including the repo where
# this manual itself lives.
EXCLUDE='node_modules|/\.|/docs/archive/|/docs/adr/|/CHANGELOG\.md|ai_governance_[a-z]+\.md'

while IFS=: read -r file _ ref; do
  ref="${ref%\`*}"
  [[ -e "$ref" ]] || { echo "BROKEN: $file → $ref"; rc=1; }
done < <(grep -rnoE '`(docs|src|features|tools)/[A-Za-z0-9._/-]+`' --include='*.md' . \
         | grep -vE "$EXCLUDE" | tr -d '`')

[[ $rc -eq 0 ]] && echo "docs ok"
exit $rc
```

Wire it as `docs:check` in your task runner. Run it when documentation changes — not on every
turn.

### Periodic audit (optional)

Once a month, or when the system feels heavy: read `AGENTS.md` and ask *which mandatory rule is
being disobeyed most often?* Then fix the rule, not the behavior. A rule with a 50% compliance
rate is telling you something true.

---

## 10. Project Skills (vendor-neutral)

Most agent tools support some form of reusable named procedure — skills, commands, prompts,
modes. The mechanism differs; the useful set does not. Define these by **role**, and implement
them however your tool allows:

| Skill role | Trigger | What it does |
|---|---|---|
| **bootstrap** | New project, or governance missing | Runs §9 scaffolding, fills `AGENTS.md` from the §8 template with project specifics, writes the first `INC-001`. |
| **feature-plan** | "Implement feature X" | Reading order → `features/<name>/SPEC.md` + `PROMPT.md` (`mode: plan` output, `mode: implement` handoff). Never writes source code. |
| **feature-increment** | Executing a handoff | The Phase 2 loop: verify → implement (or delegate) → re-run gate → document → next handoff or retire. |
| **review** *(optional)* | Increment implemented, before it is documented as done | Reads the diff on two axes — does it meet the spec, does it meet this repo's standards — and reports findings without applying them. §7 rule 7 says *verify*; this is a procedure for the half a gate cannot check. |

Keep skills thin. A skill that restates `AGENTS.md` is a second copy that will drift; a skill
should encode *sequence*, and point at `AGENTS.md` for *rules*.

---

## Anti-Patterns

| Anti-pattern | Why it's harmful | Correct approach |
|---|---|---|
| Feature-grade ceremony on a bugfix | Overhead gets abandoned wholesale, including where it mattered | Tier the work (§2) |
| Mandatory ADR on mechanical increments | ADRs that record nothing dilute the ones that do | ADR only when alternatives existed (§5) |
| Stack details in both `AGENTS.md` and `ARCHITECTURE.md` | Double maintenance, guaranteed drift | `ARCHITECTURE.md` owns it; `AGENTS.md` points |
| Behavioral rules in both system prompt and `AGENTS.md` | Paid for on every turn, drifts out of sync | One canonical home, one pointer (§7) |
| Shipped feature still sitting in `features/` | Next session believes work is unfinished | Retirement is part of the last increment (§4) |
| "Task complete" with no CHANGELOG entry | No trace of what was done | Every Small+ increment lands in CHANGELOG |
| Hand-assigned INC numbers | Collisions, gaps, disputes | Always CHANGELOG head + 1 |
| Long monolithic sessions | Context bloat, early instructions forgotten | Split at handoff boundaries |
| Ending a turn with "shall I proceed?" | Burns a round trip, violates self-conclusion | Deliver, report, stop |
| Handoff file with no `mode` banner | Agent guesses its role and often guesses wrong | Front-matter `mode` + first-line banner (§6) |
| Trusting a worker's "tests pass" | The most expensive lie in the loop | Re-run the gate yourself (§7 rule 7) |
| Auto-repairing a malformed handoff | Hides that the previous session's model of the repo was wrong | Stop and report |
| Planning that lives only in chat | Lost on the next clear | Write `SPEC.md` before implementing |
| Building for a requirement nobody stated | Speculative abstraction is code maintained forever to serve a guess | Simplest thing that works (§7 rule 8) |
| "Just this once" bypass of an invariant | Normalizes deviation; the system erodes from the exception, not the rule | If an invariant is wrong, change it deliberately — don't route around it |
| Vendor paths hard-coded into the governance doc | Breaks on the next tool | Rules are portable; placement is per-project (§7) |
| A messaging or tool protocol used as a delegation transport | The task arrives as untrusted chat input to a session that isn't bound to the repo | Delegation starts a *fresh, repo-bound* session (rationale §12) |
| Delegating micro-questions | Every call pays a fixed multi-thousand-token floor before reading the task | Delegate consistent batches, or do it inline (rationale §12b) |

---

## Appendix — Quick Reference

```
TIER THE WORK
  typo/one-liner        → just do it
  contained fix         → CHANGELOG entry only
  feature               → full lifecycle below

PLAN (reasoning session)
  AGENTS.md → ARCHITECTURE → PROJECT
  write features/<name>/SPEC.md + PROMPT.md  (mode: implement, banner on line 1)
  do NOT implement

IMPLEMENT (fresh session)
  verify handoff vs repo (paths, inc_base)
  implement scope → run gate → record exit codes
  CHANGELOG (INC from head) · ADR only if a decision was made · update SPEC
  work remains → HANDOFF.md   |   done → RETIRE

RETIRE (part of the last increment)
  SPEC.md → docs/archive/features/INC-<closing>_<name>.md
  delete features/<name>/
  update PROJECT.md (+ ROADMAP.md if a milestone closed)

FILE MAP (one question, one answer)
  HOW to work      → AGENTS.md
  WHAT it is       → docs/ARCHITECTURE.md
  WHO it's for     → docs/PROJECT.md
  WHERE it's going → docs/ROADMAP.md
  WHAT changed     → CHANGELOG.md (INC-XXX)
  WHY a decision   → docs/adr/ADR-NNN.md
  STATUS of a feat → features/<name>/SPEC.md
  WHAT it decided  → docs/archive/features/INC-<n>_<name>.md

NEVER
  trust a "tests pass" claim · auto-repair a handoff · hand-assign an INC
  duplicate a rule in two homes · leave a shipped feature in features/
  abstract for one caller · scaffold for a requirement nobody stated
```
