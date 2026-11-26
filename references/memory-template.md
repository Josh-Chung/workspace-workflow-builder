---
id: memory-template
scope: "MEMORY.md template: four parallel categories, shared and private memory, Write Rules, Cleanup Policy"
read-when: "Phase 4 generation, when MEMORY.md is part of the deliverable set"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, generation, category-b, memory]
---

#### `MEMORY.md` - Project Memory (Four Parallel Categories)

````markdown
# MEMORY.md - Project Memory

> **Scope:** Persistent per-project memory. Read at session start (with
> `CHANGELOG.md`), written per Write Rules below. Ships empty. The **only**
> workflow file agents modify on their own initiative -- all others are read-only.

> **Encoding:** structure in English; entries in project's working language.
> UTF-8-safe edits only (BD-5), prefer targeted edits, inspect diff after
> every edit. No emoji.

---

## Memory Architecture

**Strategy:** <derived from B2: session-level / persistent / hybrid>
**Categories:** Project Memory, Decision Memory, Error Memory, Operational Rules
<if B3 = B or C: plus shared / private extensions below>
**Anti-duplication:** `MEMORY.md` = facts, decisions, lessons, rules.
`CHANGELOG.md` = file-level changes. `docs/` = requirements/design. One home
per item -- link, do not copy.

---

## Project Memory

*Fundamental facts (identity, stack, constraints). Permanent; corrected in place.*

| Key | Value | Last Updated | Updated By |
|---|---|---|---|
| | | | |

## Decision Memory

*Confirmed decisions + rationale. Permanent; reversed = marked Superseded.*

| Decision | Rationale | Alternatives Considered | Date | Agent | Status |
|---|---|---|---|---|---|
| | | | | | |

## Error Memory

*Failures, dead ends, invalidated info. Permanent while active; condensable once prevented.*

| Error | Context | Root Cause | Resolution | Date | Agent | Status |
|---|---|---|---|---|---|---|
| | | | | | | |

## Operational Specification Rules

*Durable rules governing agent behavior across sessions. Permanent; corrected
in place. Agents' writable home for rules (instruction files are read-only).*

**Rule maintenance:** update immediately when a rule is declared, identified,
or corrected. Include brief *Why* when not self-evident. Conflicts with
instruction files: surface to user.

<Seed at initialization with the rules applicable to this project's stack.
Universal starter set: UTF-8-safe editing with post-edit diff inspection; no
emoji in CLI output; follow .workflow-references/GIT_WORKFLOW.md for all git operations; strict pass
reporting (never report PASS for a test that did not run to completion).
Branch D adds: citation discipline (every factual claim carries a verifiable
source; unverifiable claims are flagged [UNVERIFIED], never silently kept);
no-fabrication of sources. Branch E adds: reproducibility discipline (fixed
seeds, pinned versions, data snapshots); experiment log is mandatory and a
living document; negative results are recorded, never discarded. Branch P
adds: capability honesty (never attribute to the target runtime a capability
it lacks); wording precision (every rule is testable, every gate has a
fallback); adversarial test failures are Error Memory entries. Branch O adds:
rollback strategy is mandatory before any change; blast radius of every
change is documented; BLOCKED boundary explicitly delineated (locally
verifiable vs. requires production). Branch C
adds: style-guide adherence (docs/style_guide.md is binding); platform rules
are recorded as Operational Rules, never guessed.>

[B3 = B or C ONLY]:
## Shared Memory (Cross-Agent)

*Scope: the board agents use to pass work and information to each other.
Every agent reads it; only a row's Owner edits that row. To ask another agent
for something, add a new row with that agent as Owner -- never edit another
agent's row. Status is `Open`, `Taken`, or `Done`.*

| Key | Value | Owner | Status | Last Updated | Updated By |
|---|---|---|---|---|---|
| | | | | | |

[B3 = C ONLY]:
## Agent-Specific Private Memory

*Scope: per-agent, writable only by the named agent.*

#### <Agent> Private
| Key | Value | Last Updated |
|---|---|---|
| | | |

---

## Write Rules

| Memory Type | Who Writes | Trigger (bound to the workflow) | Must Include |
|---|---|---|---|
| Project Memory | Human + agents | A fundamental fact is established or changes: URD/PRD confirmation gates, scope-altering "Sync Docs" events | Key, value, date, who established it |
| Decision Memory | Agents | Immediately after the user confirms a significant decision: requirement gates, stack selection, scope pivots, architecture changes | Rationale and alternatives considered |
| Error Memory | Agents | Immediately when a failure, dead end, or invalidated piece of information is confirmed: Step 4 root causes, QA findings, external facts that proved wrong | Root cause and resolution (or `Status: Open`) |
| Operational Rules | Human + agents | Immediately when the user declares a durable rule, an agent identifies one needed for future sessions, or an existing rule proves wrong or incomplete | The rule statement and a brief *Why* |

**Write discipline:**
- Write before "done" -- task incomplete until memory row exists.
- One row per item, updated in place (never duplicate rows).
- Only decisions costly to re-derive; routine choices belong in `CHANGELOG.md`.
- No transient content (session details, code diffs, progress notes).
- **Status values:** Decision: `Active` / `Superseded by <date> <decision>`.
  Error: `Open` / `Resolved` / `Promoted (<where>)` (= structural guard exists).

---

## Memory Cleanup Policy

<Derived from B9. Core always present; B9=B adds time-window; B9=C adds
iteration review; B9=D replaces per-category retention with custom rules.>

Cleanup = condensing or marking, almost never deleting.

**Triggers:**
1. **Handoff (PHASE 2 Step 6):** mandatory consolidation
2. [B9 = C]: **New iteration:** review + mark superseded decisions
3. **Size ceilings:** rows -- Project 30, Decision 50, Error 30; bytes -- any
   table cell over 2 KB, or the file over 32 KB. Check both: a single 40 KB
   cell is one row on one line, so row counts report it as compliant
4. **Manual:** user issues `MEMORY CLEANUP`
5. **Archive:** final pass, then freeze
[B9 = B]: 6. **Time window:** every <N> days, condense Resolved/Promoted/Superseded

**Per-category:** Project -- merge duplicates, keep newest, never delete.
Decision -- reversed = `Superseded`, chains of 3+ condensed to final. Error --
prevented = `Promoted (<where>)`, condensable. Rules -- update in place, remove
only on user instruction.

**Protected (never touch):** `Active` decisions, `Open` errors, non-retired
rules, rows referenced by open tasks/PRD/URD.

**Audit:** one line per cleanup pass in Cleanup Log. Targeted edits only.

---

## Cleanup Log

| Date | Action |
|---|---|
| | |
````

---
