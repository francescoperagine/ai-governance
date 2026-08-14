# AI Project Governance — Template

**Template version: 1**

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
> §11–§13 are optional automation: skip them unless the user asked for automation.
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
> (manual operation, any tool). §11+ is optional automation (needs headless invocation or
> subagent spawning).
>
> **Design constraint: nothing here may depend on a specific vendor, model, or subscription
> tier.** Where a vendor is named it is a reference implementation, clearly marked as such.

---

## 0. How To Use This Document

Three ways in, in increasing order of effort.

**Read it yourself** if you want to understand the system: §1–§5 is the whole thing. §6 is the
mechanism that makes multi-session work reliable. §11+ is optional and can wait forever.

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
| **Ignore entirely** | Everything in §11–§15. Projects don't consume the template's own rationale. |

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
| **Self-concluding sessions** | A task ends with a deliverable, not a question. |
| **Verification, not trust** | A claim that "tests pass" is not evidence. The exit code is. |
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
2. Create features/<feature-name>/   (kebab-case)
3. Write SPEC.md — scope, decisions, acceptance criteria, phase ledger
4. Write PROMPT.md — self-contained entry point, mode: implement
5. Self-conclude: deliver SPEC.md + PROMPT.md. Do NOT start implementing.
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

Before a handoff is executed — by a human glance or by a script (§11):

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

7. **Verify, don't trust.** A subordinate's report that the gate passed is not evidence.
   Re-run the gate; the exit code decides. Read the diff of what a worker changed before
   documenting it as done.

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

[EITHER paste the seven rules from §7 of the governance template here,
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
while IFS=: read -r file _ ref; do
  ref="${ref%\`*}"
  [[ -e "$ref" ]] || { echo "BROKEN: $file → $ref"; rc=1; }
done < <(grep -rnoE '`(docs|src|features|tools)/[A-Za-z0-9._/-]+`' --include='*.md' . \
         | grep -v node_modules | tr -d '`')
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
modes. The mechanism differs; the useful set does not. Define these three by **role**, and
implement them however your tool allows:

| Skill role | Trigger | What it does |
|---|---|---|
| **bootstrap** | New project, or governance missing | Runs §9 scaffolding, fills `AGENTS.md` from the §8 template with project specifics, writes the first `INC-001`. |
| **feature-plan** | "Implement feature X" | Reading order → `features/<name>/SPEC.md` + `PROMPT.md` (`mode: plan` output, `mode: implement` handoff). Never writes source code. |
| **feature-increment** | Executing a handoff | The Phase 2 loop: verify → implement (or delegate) → re-run gate → document → next handoff or retire. |

Keep skills thin. A skill that restates `AGENTS.md` is a second copy that will drift; a skill
should encode *sequence*, and point at `AGENTS.md` for *rules*.

---

## 11. Optional: Automated Orchestration

> **Everything above works with a human clearing context between sessions.** This part removes
> the human from phase boundaries. It is optional, and it is not free.

### When automation is worth it

- The feature is genuinely multi-increment and the spec is mechanical.
- You want unattended runs (overnight, or while doing something else).
- You have the throughput budget for a chain that may burn several sessions before you look.

### When it is not

- **Single-increment tasks.** The loop costs more than it saves.
- **High-uncertainty exploration.** If the SPEC has open questions, every link needs a human.
- **First-time project setup.** Review the scaffolding before automating on top of it.
- **Weak or unproven reasoner models.** Automation multiplies model error.
- **No headless mode and no subagent spawning.** Then the human is the orchestrator, and this
  section is a specification of desired behavior rather than a runnable system.

### The pattern: flat and sequential, never recursive

A naive design has each session spawn the next one and "self-terminate". This does not work in
real delegation systems: spawning creates a *child* one level deeper, not a lateral handoff, so
a chain of k links needs nesting depth k+1; and in most systems the parent must stay alive
while the child runs, so interrupting the top cancels everything below.

The correct topology is **one long-lived thin dispatcher** driving a **sequence of fresh
sessions**:

```
Human: "Implement feature X"
  → Dispatcher
      → plans the feature: SPEC.md + PROMPT.md                   [link 0]
      → LOOP while a handoff file exists (bounded, see below):
          → validate the handoff contract (§6) — mechanically
          → launch a FRESH session pointed at the handoff file
          → that session may delegate mechanical work to a worker,
            re-runs the gate itself, updates docs, writes the next
            handoff or retires the feature, returns a SHORT summary
          → cross-check the summary against disk, then iterate
      → report "feature complete: INC-XXX…INC-YYY", or the stop diagnosis
```

Nesting depth stays constant (dispatcher → session → worker = 2). Chain length is unbounded
because links are sequential siblings. The dispatcher's context grows by a few lines per link
because each link returns a summary, never a transcript.

### Link protocol (each session in the chain)

```
1. READ the handoff file
2. VERIFY repo state against its assumptions (paths, inc_base, gate commands exist)
3. PLAN the increment (which files change, in what order)
4. DELEGATE mechanical implementation to a worker
5. VERIFY MECHANICALLY — read the diff; RE-RUN the gate yourself.
   A worker's claim of "tests pass" is never evidence.
6. UPDATE docs IDEMPOTENTLY — if an INC entry for this phase already exists at the
   CHANGELOG head (a prior run crashed after implementing), complete only what's missing.
   Never duplicate an INC number.
7. DECIDE — next phase exists → write HANDOFF.md; else → retire the feature (§4 Phase 4)
8. RETURN { completed: INC-XXX, gate: <command + exit code>, handoff: <path|none>,
            divergences: [...] } and TERMINATE
```

**The worker never** updates CHANGELOG/ADR/SPEC, decides the next increment, writes the
handoff, or certifies success. It implements a file list and reports commands with exit codes.

**The dispatcher never** designs, implements, documents, repairs a malformed handoff, or
overrides a stop condition.

### Parallelism: what the runtime handles, and what it can't

An orchestrator runtime does handle spawning, scheduling, and a concurrency cap (Hermes:
`max_concurrent_children`, default 3). What no runtime handles is **write contention on the
shared files this system runs on** — it has no idea `CHANGELOG.md` is a numbering authority.
That part is the framework's job, and the rule is one line:

**Parallelize within an increment. Never across increments.**

The increment protocol reads the CHANGELOG head and adds one. Two increments in flight produce
either a duplicate `INC` or a lost update. The `inc_base` check (§6) exists to *detect* that
aftermath — detection is not prevention.

| Shape | Safe | Why |
|---|---|---|
| Read-only fan-out: exploration, audits, reviewing different files | **Yes** | No shared writes. This is the highest-value parallelism here and it's underused. |
| Several workers on **disjoint file sets** within one increment | **Yes** | Scopes don't overlap, and the reasoner does every documentation write afterwards, serially. |
| Two workers touching the same file | No | Last writer wins, silently. |
| Two increments of one feature | No | `INC` collision, CHANGELOG lost update, SPEC ledger race. |
| Two chains in one working tree | No | All of the above, plus git contention. One chain per working tree — use a second worktree or clone if you genuinely need two. |

The invariant that makes the safe row safe is one this system already had: **a worker never
writes `CHANGELOG.md`, an ADR, or `SPEC.md`.** All shared-file mutation is serialized through
the single reasoner that owns the increment. Parallelism is therefore a property of the *scope
split*, not of the runtime — if two scopes are disjoint, run them together; if you can't state
that they're disjoint, they aren't.

### Bounded autonomy

- **Link cap per unattended run: 5 by default.** After the cap, stop and report even if a
  handoff exists. The human resumes explicitly.
- **Hard escalation triggers:** any open decision surfacing in a SPEC, any schema or contract
  change, any divergence between handoff assumptions and repo state.
- **Trust budget scales with the model.** With a mid-tier reasoner, halve the cap and review
  each ADR before the next run. The *pattern* is model-agnostic; the *trust* is not.

### Failure handling

| Failure | Action |
|---|---|
| Worker errors, or gate non-zero | Session fixes wrong handoff-level assumptions and retries the worker **once**. Still failing → stop diagnosis; dispatcher halts. |
| Gate passes for the worker, fails on re-run | The claim was wrong. Do **not** document. Return divergence; halt. |
| Handoff references a nonexistent file | Contract validation catches it before launch. Halt. |
| Handoff missing or malformed | Halt and report. Never auto-repair. |
| CHANGELOG head ≠ `inc_base` | A prior link crashed mid-way, or chains ran concurrently. Halt; human reconciles — the idempotent step 6 makes this mechanical. |
| Chain interrupted mid-link | Restart the loop. Contract validation + `inc_base` locate exactly where it stopped. |
| Nesting depth unavailable | Degrade: the session implements directly (`DIRECT` strategy). Sequencing never depended on nesting. |

### Testing the loop before trusting it

Run a throwaway feature — "create a hello-world increment" — and confirm the full path:
plan → one link → gate green → CHANGELOG advanced by exactly one → feature retired → clean
report. Then **deliberately break it**: corrupt the front-matter (expect a stop *before*
launch), fake a passing worker claim against a red gate (expect the re-run to catch it), and
kill a link mid-run (expect `inc_base` to locate the break on restart).

*A chain you have never watched fail is a chain you cannot trust.*

---

## 12. Reference Implementations

The pattern needs exactly one capability: **a way to start a fresh agent session
non-interactively**. Two shapes.

### 12a. Shell loop (most portable, most robust)

Each link is an independent OS process. Nothing carries over, nothing nests, and the state
lives on disk — so a crashed run is resumable by re-running the script.

```bash
#!/usr/bin/env bash
# dispatch.sh <feature-name> — adapt the AI invocation to your tool.
set -euo pipefail
feature="$1"; dir="features/$feature"; max_links=5

for ((i=1; i<=max_links; i++)); do
  handoff="$dir/HANDOFF.md"; [[ $i -eq 1 ]] && handoff="$dir/PROMPT.md"
  [[ -f "$handoff" ]] || { echo "feature complete"; exit 0; }

  validate_frontmatter "$handoff"          || { echo "STOP: malformed handoff"; exit 1; }
  check_inc_base "$handoff" CHANGELOG.md   || { echo "STOP: INC mismatch";      exit 1; }

  # One fresh session per link — prompt as argument or via stdin, per your CLI:
  #   <your-ai-cli> --headless "$(cat "$handoff")"
  #   <your-ai-cli> --headless < "$handoff"
  run_ai_session "$handoff"                || { echo "STOP: link failed";       exit 1; }

  run_gate_from_frontmatter "$handoff"     || { echo "STOP: gate red";          exit 1; }
  [[ -f "$dir/HANDOFF.md" ]]               || { echo "feature complete";        exit 0; }
done
echo "STOP: link cap reached — human review required"
```

| Property | How it's achieved |
|---|---|
| Fresh context per link | New process per iteration |
| Unbounded chain length | The loop, not nesting |
| Mechanical validation | Front-matter checks run in the script, outside any model |
| Verification without trust | The script re-runs `gate_commands`; exit codes decide |
| Clean failure | Any check fails → stop with a diagnosis; all state is on disk |
| Survives the agent tool | A crashed session doesn't destroy the chain — re-run the script |

### 12b. In-agent dispatcher (example: Hermes Agent)

Reference only. Convenient when you want live progress and one session to talk to.

> **Cached external facts — verified against the Hermes Agent docs on 2026-08-14
> (`hermes-agent.nousresearch.com/docs/user-guide/features/delegation` and
> `/docs/guides/delegation-patterns`).** They are recorded here so a session doesn't have to
> re-explore vendor docs to act. **On any conflict, the live docs win and this block is the
> thing that's wrong** — fix it in the same increment that discovers the drift. What the
> *pattern* needs is in §11 and does not depend on any of this.

- `delegate_task` spawns an **isolated child**: own conversation, own terminal session, own
  toolset. The child sees only the `goal` and `context` strings — no conversation history.
  Only the child's **final summary** returns to the parent.
- **Top-level delegation is asynchronous**: Hermes returns a handle immediately and posts the
  result back as a new message. Delegations made *by* an orchestrator child are synchronous —
  that child blocks on its workers.
- **Durability is partial.** Normal follow-up messages do **not** cancel running background
  children. But `/stop` cancels them, and `/new`, closing the session, or a process restart
  discards or strands in-progress work. Everything stays tied to the owning process. For work
  that must survive those boundaries the docs point to `cronjob` or
  `terminal(background=True, notify_on_complete=True)`.
- **Children are stripped of** `delegate_task` (leaf children only), `clarify`, `memory`,
  `send_message`, and `cronjob`. **Both roles keep `execute_code`.**
- `max_spawn_depth` **defaults to 1** (flat). This pattern needs **2**
  (dispatcher → session → worker) and never more.
- `max_concurrent_children` defaults to 3, configurable, no hard ceiling.
- **Model selection: no per-task parameter.** If omitted, subagents use the parent's model.
  A global `delegation.model` setting overrides that for *all* delegations.

```yaml
# ~/.hermes/config.yaml
delegation:
  max_spawn_depth: 2           # REQUIRED — default 1 forbids the worker level
  max_concurrent_children: 3   # 1 per link is what this pattern uses
  orchestrator_enabled: true
  # model: <cheaper-model>     # optional: applies to ALL delegated children
```

**Two consequences worth internalizing:**

1. **Cost tiering is possible, but only globally.** Rule 4's task tiering is primarily *process*
   tiering here — context isolation, restricted toolsets, capped iterations. If you want
   workers on a cheaper model, `delegation.model` gets you there for every child at once; a
   genuinely per-role model requires running that role as an external headless process
   (§12a) or a separate profile.

2. **For truly unattended runs, prefer §12a.** In-agent delegation is tied to a session and a
   process; the shell loop is tied to neither, and its state is on disk. Use the in-agent
   dispatcher when you're around to watch; use the shell loop when you're not.

**Operational rule: don't message the dispatcher while a chain is running.** Not because it
destroys work — background children survive a normal follow-up message — but because the
dispatcher must break out of its loop to handle you, re-establish where it was, and resume.
That re-orientation costs tokens on every interruption and is the most common way a chain
derails into doing something you didn't ask for. If you must intervene, intervene at a link
boundary. `/stop`, `/new`, closing the session, or restarting the process *do* discard
in-flight work.

### 12c. Which model runs which role

The system's task tiering (§7 rule 4) only becomes *cost* tiering if the roles can run on
different models. How that's achieved depends on a constraint most people meet the hard way:

**Subscription plans are generally first-party only.** A chat subscription entitles you to a
vendor's own clients — their web app, their CLI, their IDE extension. It does not, as a rule,
authorize a third-party agent framework to spend that subscription. Third-party tools need a
metered API key, billed separately from the subscription you already pay for. Where a given
framework *does* work against some vendor's subscription, that's a vendor-specific auth path,
not a general capability — so "it works with vendor A" predicts nothing about vendor B. This is
policy, not configuration: no config file fixes it.

The practical arrangement that falls out of this:

| Role | Runs on | Billing |
|---|---|---|
| **Reasoner** — planning, specs, verification, docs | The vendor's own client, on your subscription | Flat / already paid |
| **Worker** — mechanical implementation from a complete spec | A cheap metered model in the agent framework | Per-token, small |

This is the arrangement §12a exists for: the shell loop invokes whatever CLI you want per link,
so the reasoner and worker roles need not share a provider at all. The in-agent dispatcher of
§12b can only apply one model per install (a global setting), which makes it fine for the
worker tier and unsuitable for mixing tiers.

**Do not fight this by trying to route a subscription through a third-party tool.** Either pay
metered for that vendor's API, or keep the reasoning role inside the vendor's own client and
let the framework drive the cheap tier.

**Agent memory is never part of the bridge.** `memory` is stripped from children, so a spawned
session can neither read nor write it. Durable facts discovered mid-chain travel the normal
way: written into `SPEC.md`, `ARCHITECTURE.md`, or the next handoff, on disk. The top-level
dispatcher may use memory for its own convenience, but the pattern must never depend on it.

---

## 13. On Context-Compression Layers (e.g. Headroom)

Context-compression proxies sit between the agent and the model provider and compress tool
output, file reads, logs, and RAG chunks in transit. They are orthogonal to this system: they
change no file and no protocol.

**They are also, for this system specifically, mostly redundant — and carry a real risk.**

- **The big win is already taken.** Fresh sessions plus disk handoffs is the highest-leverage
  context optimization available. A compressor works on the residue of sessions this system
  keeps short by design.
- **Prompt-cache interaction.** A proxy that rewrites the prompt in transit mutates the cached
  prefix. Where the provider bills cached tokens at a steep discount, a cache miss can cost more
  than the compression saves. This is mechanics, not opinion — and it is the variable most
  benchmark comparisons fail to isolate, which is why published results on these tools
  disagree so violently.
- **Lossy in exactly the wrong place.** This system depends on exact paths, exact INC numbers,
  and verbatim front-matter. File reads and tool output are the last thing you want approximated.

**Recommendation:** don't put a compressor in the path of the loop. If a tool offers an
explicit call-it-yourself mode (compress *this* blob on request) rather than a transparent
proxy, that mode is harmless — it costs only when invoked and doesn't touch the cache. Keep it
there, out of the pipeline.

If you want to evaluate one honestly, the only meaningful test holds the task fixed and reports
**total cost including cache misses**, not "tokens saved on compressed payloads". Absent that
number, assume it is a wash.

---

## 14. Anti-Patterns

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
| "Just this once" bypass of an invariant | Normalizes deviation; the system erodes from the exception, not the rule | If an invariant is wrong, change it deliberately — don't route around it |
| Vendor paths hard-coded into the governance doc | Breaks on the next tool | Rules are portable; placement is per-project (§7) |

---

## 15. Rationale FAQ

**Why disk handoffs instead of long conversations?**
Context windows fill. Past a few dozen turns the agent forgets early instructions and the
prompt bloats with irrelevant history. Writing the handoff to disk and starting fresh resets
completely — the new session reads only what it needs. This is the single highest-leverage
optimization in the system, and it requires no tooling at all.

**Why `INC-XXX` rather than semver or dates?**
Monotonic, auto-assigned from the CHANGELOG head, never hand-picked. Immune to scope disputes
("is this a patch or a minor?") and ordering disputes. Short and unique — ideal for
cross-references and, now, for archive filenames.

**Why split ARCHITECTURE / PROJECT / ROADMAP?**
Different questions, different update frequencies. ARCHITECTURE changes when topology changes
(rarely). PROJECT changes when focus shifts (weekly). ROADMAP changes when strategy does
(monthly). Merged, the file is always partially stale. Read in a fixed order, splitting costs
no extra context.

**Why "code wins" over docs?**
Docs drift; code is executable truth. When `AGENTS.md` says `src/data/` and the code moved to
`src/content-packs/`, the code is right. Always verify paths against the real repo.

**Why is retirement part of the last increment rather than its own phase?**
Because a step that happens "after you're done" never happens. Anything without a gate decays.
Folding it into the completion checklist gives it the same enforcement as the build.

**Why allow "no ADR"?**
Because a rule obeyed half the time teaches the agent that mandatory rules are negotiable — and
that leaks into the rules that matter. Narrowing the rule to what is actually always true makes
it enforceable again.

**Isn't the archive redundant with git?**
Partly. Git holds the bytes; the archive holds them *findable*. The ADR keeps the decisions, the
archived SPEC keeps the ledger — scope, exclusions, deferrals. If you never open the directory,
delete it and rely on git. Just make that a decision rather than a drift.

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
```
