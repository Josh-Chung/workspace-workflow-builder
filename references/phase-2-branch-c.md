---
id: phase-2-branch-c
scope: "PHASE 2 procedure template for Branch C (Content Operations) -- generated when A1 = E"
read-when: "Phase 4 plan document generation, only when A1 = E selects Branch C"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, phase-2, branch-c, generation, category-b]
---

#### `.workflow-references/phase-2-execution.md` - Branch C (Content Operations)

> Generated when **A1 = E**. Only one branch is generated per project.
> Fragment markers (`<!-- USE: X -->`) reference Shared Step Fragments defined
> in `agent-file-templates.md` and are expanded at generation time per the
> fragment expansion rule there. `[COMBINATION: secondary=<branch>]` blocks are
> included only when A1-combo selected that secondary branch; they contribute
> Step 5 QA checklist items only. The entry file carries a one-liner reference
> to the generated `.workflow-references/phase-2-execution.md`.

````markdown
[GENERATE WHEN A1 = E]:

# PHASE 2 - Content Operations (Strategist, Writer & Editor Modes)

> **Scope:** Complete PHASE 2 procedure. Read this file when entering
> PHASE 2 (Path A confirmed from PHASE 1, or bug fix routing to Step 4).

---

*Two working levels: **channel level** (strategy, voice, calendar - enters via
full PHASE 1) and **piece level** (individual content items - enters via the
Content Brief route defined in Entry Point Routing). Most sessions are piece
level.*

**Strict sequential execution:** complete each step fully before moving to
the next. Do not skip, reorder, or combine steps.

<!-- USE: CHANGE_LOG_INJECT -->

<!-- USE: CHECK_LADDER -->

**Step 1: Channel & Calendar Planning** *(channel level only)*.
- Propose the channel strategy: platforms, audience, positioning, cadence.
- Create or update the **Style Guide** (`docs/style_guide.md`) - voice, tone,
  vocabulary, banned phrases, formatting norms per platform. It is a **living
  document** and is binding on every piece produced.
- Create or update the **Content Calendar** (`docs/content_calendar.md`).

**Step 2: Drafting** *(entry point for piece-level work)*.
- Draft against the confirmed Content Brief and the Style Guide: hook,
  structure, voice, length per the target platform.
- <!-- USE: CLAIMS_DISCIPLINE -->
- **Checkpoint:** one draft-direction confirmation per piece is enough -
  do not re-interrogate settled Style Guide decisions.
[LOOP FIT = loop ONLY]:
- <!-- USE: RED_FIRST -->

**Step 3: Platform Adaptation & Polish.**
- Produce per-platform variants (length, format, hashtags, link handling)
  from the master draft - the master stays the single source of truth.
- **Capability gate:** platform constraints and trends are stated only from
  verifiable sources or the user's own input - never fabricate platform
  rules, algorithm claims, or engagement statistics.
- <!-- USE: PRODUCT_AI_READABILITY -->
- <!-- USE: VISUAL_PRESENTATION -->
- <!-- USE: PRINT_OUTPUT -->

**Step 4: Revision Loop.**
- Apply user feedback surgically (BD-2): revise the flagged parts; do not
  silently rewrite approved copy.
- Resolve every `[UNVERIFIED]` marker before the piece moves to Step 5.
- Recurring feedback (same correction twice) is promoted into the Style Guide
  and recorded in `MEMORY.md` (Decision Memory or Operational Rules).

**Step 5: Pre-Publish QA (Editor Mode).**
[LOOP FIT = loop ONLY]:
- <!-- USE: CHECK_EXECUTION -->
- Run the checks accumulated during Steps 2-4, then the pre-publish checklist
  per piece: factual claims sourced; voice
  matches the Style Guide; platform constraints met; no placeholder text or
  `[UNVERIFIED]` markers; call to action present and correct; links resolve.
- **Branch C blocked examples:** in-platform preview, scheduling, account state.
  <!-- USE: BLOCKED_CLAUSE -->
- <!-- USE: LOOP_CAP -->
- **Product AI-readability:** domain-appropriate machine-readability checks
  per the PRODUCT_AI_READABILITY provisions in Step 3. Any check the agent
  cannot perform is marked BLOCKED.

[COMBINATION: secondary=S]:
- **Borrowed from Branch S QA:** test plan covers any automated or scripted
  components, browser-based verification executed or BLOCKED.

[COMBINATION: secondary=D]:
- **Borrowed from Branch D QA:** citation integrity (every factual claim has a
  source or is marked `[UNVERIFIED]`), factual accuracy spot-check, and
  cross-version parity (if multiple language versions).

**Step 6: Publish Support & Retrospective.**
- Provide the publish checklist (timing, platform steps, assets).
- After publication, record outcomes the user reports (what worked, what
  flopped) into `MEMORY.md` - Decision Memory for direction calls, Error
  Memory for misfires - and fold durable lessons into the Style Guide.
- <!-- USE: HANDOFF_MEMORY -->
- <!-- USE: TEMP_CLEAR -->

---
````
