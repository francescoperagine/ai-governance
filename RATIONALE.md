# AI Project Governance — Rationale & Optional Automation

**Companion to [`TEMPLATE.md`](TEMPLATE.md).**

> **Adopting projects do not read this file.** The template says so itself: everything here is
> either optional automation or the system's own rationale, and neither is something a project
> consumes. It lives apart so that revising it — reference implementations age, cached vendor
> facts age faster — never forces a version bump on projects that already adopted the system.
> The template's version number is reserved for changes that require an adopting project to do
> something; nothing in this file ever does.
>
> **Section numbers are unchanged** from when this was §11–§15 of a single document.
> Renumbering would invalidate every existing cross-reference and buy nothing. A `§` reference
> below numbered 11–15 points inside this file; any lower number points into the template.

Read this if you are automating phase boundaries (§11–§12), evaluating a context-compression
proxy (§13), or asking why the system is shaped the way it is (§15). The anti-pattern table and
the quick reference stayed in the template: they are operational indexes, not rationale.

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
non-interactively, pointed at this repository, that returns a summary when it is done.**

All three properties are load-bearing. *Fresh* — no inherited context, or §6 was pointless.
*Pointed at this repository* — the worker reads the repo's files and inherits the repo's rules,
or it is guessing. *Returns a summary* — the reasoner's context grows by a few lines per link,
not by a transcript.

Most agent-interop channels provide none of the three. Check before adopting one:

| Channel | What it actually is | Fit as a delegation transport |
|---|---|---|
| **Headless CLI invocation** | One OS process per task, given the repo path | **Yes.** Fresh by construction, repo-bound by argument, exits with the result. §12b. |
| **In-agent subagent spawn** (a `delegate_task`-style tool) | A child inside the running agent process | **Yes, while you're watching.** Dies with the session. §12c. |
| **Agent-to-agent messaging protocols** (A2A and every chat bridge) | A task delivered as a *message* to an already-running agent | **No.** See below. |
| **MCP** | A server exposing *tools* to an agent | **No.** MCP gives an agent capabilities; it does not start an agent. |

**Why an agent-to-agent messaging protocol is not a delegation transport.** It looks like one:
an orchestrator assigns a task to an independent agent, which uses its own tools and returns a
result. The failure is in the middle of that sentence — *already-running*. A task arriving over
a messaging protocol lands in a live session, in whatever working directory that session
happens to have, sharing that session's memory and history. There is no repo argument, so
nothing binds the work to the project whose rules the handoff assumes. Worse, a well-built
implementation treats peer input as **untrusted** — injection-filtered, redacted on the way
out, operator commands refused — which is correct for an internet-facing endpoint and exactly
wrong for a handoff, whose whole value is being a precise, trusted instruction set. Add that
the orchestrator usually has no client for the protocol anyway (so you wrap it in a tool
server or a shell command, arriving back where you started), and it is a long path to a worse
version of `<cli> --one-shot --in <repo>`.

Use those protocols for what they are: reaching an agent that is *already alive and elsewhere*
— notifications, cross-machine chat, a human in the loop on a phone. Not for making one.

> **Cached external fact — checked 2026-08-14 against the Hermes Agent docs
> (`/docs/user-guide/messaging/a2a`).** Hermes' A2A support is configured under
> `gateway.platforms` alongside Telegram/Discord/Slack; inbound tasks are "injected into a live
> gateway session — the same agent, memory, and tools that serve your other channels", with
> prompt-injection filtering, outbound credential redaction, and slash commands refused for
> remote peers. That is the shape described above: a channel, not a worker spawner. Its MCP
> server (`hermes mcp serve`) exposes conversations and messages — also a bridge. **Live docs
> win on conflict**; the pattern in §11 depends on none of this.

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

### 12b. Delegating one task to an external worker (headless CLI)

This is the worker leg — what step 4 of the link protocol calls, whether the caller is the
shell loop of §12a or a reasoning session delegating a single mechanical batch.

The invocation is the same shape in every tool that has one. Five capabilities matter; the
flag names differ, the list does not:

| Capability | Why the pattern needs it |
|---|---|
| **One-shot / print mode** | Only the final result reaches stdout. No TUI, no transcript to parse. |
| **Working directory** | The worker runs *in the repo* and inherits its `AGENTS.md` — this is what makes a worker governed rather than improvising. |
| **Approval bypass** | No TTY is present. See the safety note below before using it. |
| **Isolation** (optional) | A dedicated git worktree, so parallel workers on disjoint scopes can't collide. |
| **Usage accounting** (optional) | A per-call cost report, written even when the call fails. |

```bash
<agent-cli> --one-shot "PROMPT" --model <model> --in <absolute/repo/path> \
            --auto-approve --usage-file <path>
```

> **Cached external fact — checked 2026-08-14, Hermes Agent.** The above reads
> `hermes -z "PROMPT" -m <model> --provider <provider> --in <path> --yolo --usage-file <path>`;
> `--worktree` gives the isolated tree, `--reasoning <level>` tunes effort, `--ignore-rules`
> skips repo-rule injection. **Live docs win on conflict.**

**Rule 4 in one sentence: delegate transcription, never adjudication.** A task whose output is
a judgement call — and every stage gate — stays with the reasoning session. If you cannot write
the acceptance criterion into the prompt, the task is not ready to delegate.

### When delegation is worth it

**Delegation does not reduce token spend. It moves spend off the expensive context.** Total
tokens go *up* — a delegated task costs the spec you wrote, plus a fixed startup floor, plus
the worker's own run, plus the verification you owe it under rule 7. Rule 4 already says this
out loud: preserving reasoning context is worth more than minimizing total tokens. If your goal
is the smallest possible bill, delegate less. If it is longer-lived reasoning sessions and
fewer restarts, delegate more. They are different goals; pick knowingly.

**The break-even is a ratio, not a size.** Rule 4 states the test; this is the arithmetic
behind it. Delegate when the *specification is much smaller than the work*:

```
delegate  ≈  spec + floor + verification        (verification is not optional)
direct    ≈  the context the work consumes inline
```

A task that burns 50k tokens of reading and iteration but fits in a 500-token spec is an
enormous win. A task that needs a 2k spec to save 5k of work is a loss, and you found out by
writing the spec — at which point you had already done the thinking. If you cannot compress the task, 
you have already done it: just finish it.

**Verification does not scale down.** Reading a diff and re-running a gate costs roughly the
same whether the worker touched twenty lines or two hundred. On a small task that near-fixed
cost alone can exceed doing the work inline, which is why the ratio test is necessary but not
sufficient.

**The floor is per call, so batch.** Every invocation pays for a system prompt, tool schemas,
and repo-rule injection before reading a word of the task — on one current CLI that measures
~16k input tokens for a three-word prompt. Ten micro-delegations pay it ten times. One call
with ten deliverables pays it once. Below some size the trip costs more than the cargo.

**Whose tokens are they?** The floor is only expensive if you are paying per token for it.
Where the worker runs on a subscription-covered model and the reasoner does not, the floor
costs latency rather than money, and the scarce resource is the reasoner's context and rate
limit — delegate freely, subject to the compression test above. Where the worker is metered and
the reasoner is flat, the arithmetic inverts. Establish which you are in before tuning
anything: it changes the answer more than any flag does.

**Skipping rule injection is a false economy here.** A flag that omits `AGENTS.md` from the
worker's context cuts part of the floor and, with it, the only reason the worker is governed
rather than improvising. Use it for pure transformations with no repo context — never for work
that touches the project's conventions.

**Approval bypass is only as safe as the scope.** A worker running unattended with approvals
off is bounded by exactly three things: an explicit file list in the handoff, a clean working
tree (or a dedicated worktree), and the reasoner reading the diff afterwards. If any of the
three is missing, don't pass the flag.

### 12c. In-agent dispatcher

Reference only. Convenient when you want live progress and one session to talk to; unsuitable
for unattended runs, because it is tied to a session and a process while §12a is tied to
neither.

A `delegate_task`-style tool spawns an isolated child — own conversation, own toolset, no
conversation history; only the child's final summary returns. Three constraints recur across
implementations and are worth checking in yours before relying on it:

- **Spawn depth.** This pattern needs exactly 2 (dispatcher → session → worker) and never
  more. A default of 1 forbids the worker level outright.
- **Durability.** Children die with the owning session or process. Whatever "clear the
  session" is called in your tool, it strands in-flight work.
- **Model selection is usually global, not per task.** Which means rule 4's tiering lands here
  as *process* tiering — context isolation, restricted toolsets — not cost tiering. Per-role
  models need §12a or §12b.

- **Durable alternatives usually exist alongside it.** A scheduler or a backgrounded shell
  command typically survives what kills a spawned child. If a run must outlive the session,
  that is the mechanism — not a longer-lived child.

> **Cached external fact — checked 2026-08-14, Hermes Agent.** `delegation.max_spawn_depth`
> defaults to 1 and must be set to 2; `max_concurrent_children` defaults to 3;
> `delegation.model` applies to *all* children; children are stripped of `memory`,
> `send_message`, `clarify`, and `cronjob` — but **keep `execute_code`**, which is what makes
> them useful as workers. Top-level delegation is **asynchronous** (returns a handle, posts the
> result back later); delegations made *by* an orchestrator child are synchronous. For work that
> must survive `/stop`, `/new`, or a process restart the docs point to `cronjob` or
> `terminal(background=True, notify_on_complete=True)`. **Live docs win on conflict.**

**Operational rule: don't message the dispatcher while a chain is running.** Not because it
destroys work — background children survive a normal follow-up message — but because the
dispatcher must break out of its loop to handle you, re-establish where it was, and resume.
That re-orientation costs tokens on every interruption and is the most common way a chain
derails into doing something you didn't ask for. If you must intervene, intervene at a link
boundary. `/stop`, `/new`, closing the session, or restarting the process *do* discard
in-flight work.

### 12d. Which model runs which role

The system's task tiering (§7 rule 4) only becomes *cost* tiering if the roles can run on
different models. How that's achieved depends on a constraint most people meet the hard way:

**Subscription plans are first-party by default.** A chat subscription entitles you to a
vendor's own clients — their web app, their CLI, their IDE extension. It does not, by default,
authorize a third-party agent framework to spend it; that generally needs a metered API key,
billed separately. But some frameworks *do* ship an authorized OAuth path to some vendor's
subscription, and those lists change. So: **read your framework's provider list before assuming
metered**, and don't generalize — "it works with vendor A" predicts nothing about vendor B.
This is policy, not configuration: where the path doesn't exist, no config file creates it.

The practical arrangement that falls out of this:

| Role | Runs on | Billing |
|---|---|---|
| **Reasoner** — planning, specs, verification, docs | The vendor's own client, on your subscription | Flat / already paid |
| **Worker** — mechanical implementation from a complete spec | Whatever the framework can authorize: a subscription-covered model where that path exists, otherwise a cheap metered one | Flat, or per-token and small |

This is the arrangement §12a and §12b exist for: a per-call CLI invocation names its own model,
so the reasoner and worker roles need not share a provider at all. The in-agent dispatcher of
§12c typically applies one model per install (a global setting), which makes it fine for the
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

