---
id: phase-2-branch-d
scope: "PHASE 2 procedure template for Branch D (Document & Research) -- generated when A1 = D"
read-when: "Phase 4 plan document generation, only when A1 = D selects Branch D"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, phase-2, branch-d, generation, category-b]
---

#### `.workflow-references/phase-2-execution.md` - Branch D (Document & Research)

> Generated when **A1 = D**. Only one branch is generated per project.
> Fragment markers (`<!-- USE: X -->`) reference Shared Step Fragments defined
> in `agent-file-templates.md` and are expanded at generation time per the
> fragment expansion rule there. `[COMBINATION: secondary=<branch>]` blocks are
> included only when A1-combo selected that secondary branch; they contribute
> Step 5 QA checklist items only. The entry file carries a one-liner reference
> to the generated `.workflow-references/phase-2-execution.md`.

````markdown
[GENERATE WHEN A1 = D]:

# PHASE 2 - Document & Research Delivery (Researcher, Writer & Reviewer Modes)

> **Scope:** Complete PHASE 2 procedure. Read this file when entering
> PHASE 2 (Path A confirmed from PHASE 1, or bug fix routing to Step 4).

---

*Only enter if Path A was confirmed. Start as a rigorous Research Lead -
evidence-driven, transparent about uncertainty, audience-focused.*

**Strict sequential execution:** complete each step fully before moving to
the next. Do not skip, reorder, or combine steps.

<!-- USE: CHANGE_LOG_INJECT -->

<!-- USE: CHECK_LADDER -->

**Step 1: Planning, Outline & Source Strategy.**
- Propose the deliverable inventory (documents, formats, languages) and a
  section-level outline for each deliverable, in plain language.
- Estimate scope (Simple / Medium / Ambitious) and list prerequisites
  (access to data, interviews, paywalled sources, internal materials).
- **Source Strategy:** name the classes of sources that will ground each
  section (official statistics, primary documents, peer-reviewed work,
  industry reports), and fix the citation format up front.
- **Documentation Preservation:** save the approved URD and PRD as files in
  the project directory (e.g., `docs/requirements.md`, `docs/PRD.md`). The
  outline is saved as `docs/outline.md` and is a **living document**.

**Step 2: Structured Drafting.**
- **Draft section by section.** Do not dump one massive document unless asked.
- **Surgical Edits (BD-2):** every edit traces to the outline or the
  current section's goal; revisions never silently rewrite approved sections.
- <!-- USE: CLAIMS_DISCIPLINE -->
- **Checkpoint:** stop at section gates for direction confirmation.
- <!-- USE: SYNC_DOCS -->
[LOOP FIT = loop ONLY]:
- <!-- USE: RED_FIRST -->

**Step 3: Refinement.**
- **Argument strength:** every conclusion is supported by the evidence
  presented; gaps are named, not papered over.
- **Narrative flow and audience fit:** terminology, depth, and tone match the
  declared audience; jargon is explained on first use.
- **Consistency pass:** numbers, names, and terms are identical across all
  sections and all language versions.
- <!-- USE: PRODUCT_AI_READABILITY -->
- <!-- USE: VISUAL_PRESENTATION -->
- <!-- USE: PRINT_OUTPUT -->

**Step 4: Fact-Check & Source Verification.**
- **Verify every factual claim** against its source. Resolve every
  `[UNVERIFIED]` marker: verify it, replace it, or remove the claim.
- **Never fabricate sources, data, institutions, or quotes.** A claim that
  cannot be grounded is surfaced to the user as a gap - not guessed.
- <!-- USE: DELEGATION -->
- **Source checks are breadth-first reading** - the shape delegation suits
  best. When delegating, sub-agents read the sources and return each claim's
  verdict with the quote and its location; you decide and edit the documents.
- **Invalidated information** (a source that proved wrong or unreachable) is
  recorded in `MEMORY.md` Error Memory immediately.
- If git is enabled: factual revisions to a delivered document happen on a
  dedicated `fix/<topic>` branch, merged per `.workflow-references/GIT_WORKFLOW.md` after Step 5.
- <!-- USE: MANDATORY_QA_TRANSITION -->

**Step 5: Review QA (Document Review Expert Mode) [CRITICAL].**
[LOOP FIT = loop ONLY]:
- <!-- USE: CHECK_EXECUTION -->
- *Trigger:* when all deliverables are drafted, refined, and verified.
- **Role Switch:** adopt the persona of a demanding external reviewer.
- **Action 1 (Assemble):** start from the checks accumulated during Steps 2-4;
  from the PRD and outline, add the whole-document items that could not run
  until now, covering: factual accuracy and citation integrity,
  completeness against the PRD, internal consistency, audience fit,
  formatting and language quality, and cross-version parity (if multiple
  languages or formats are delivered).
- **Action 2 (Execution):** execute the checklist item by item.
  **Branch D blocked examples:** paywalled source confirmation, domain-expert
  judgment, internal data validation.
  <!-- USE: BLOCKED_CLAUSE -->
- **Action 3 (Reporting):** save a review report as `docs/review_report.md`.
- **Action 4 (Fix & Verify):** switch back to writer role, fix findings,
  update living documents. Repeat the review loop until the checklist passes.
  <!-- USE: LOOP_CAP -->
- **Product AI-readability:** domain-appropriate machine-readability checks
  per the PRODUCT_AI_READABILITY provisions in Step 3. Any check the agent
  cannot perform is marked BLOCKED.

[COMBINATION: secondary=S]:
- **Borrowed from Branch S QA:** test plan covers all features documented in the
  PRD, browser-based verification executed or BLOCKED, and data flow diagram (if
  present) matches implementation.

[COMBINATION: secondary=C]:
- **Borrowed from Branch C QA:** voice and tone match the Style Guide (if one
  exists), platform constraints met per target platforms, no placeholder text or
  unresolved `[UNVERIFIED]` markers, and call to action present and correct.

**Step 6: Handoff.**
- Deliver the final package in the agreed formats and languages.
- Ensure `README.md`, `docs/outline.md`, and all living documents reflect the
  final delivered state.
- Suggest what could be added or improved in the next version.
- <!-- USE: HANDOFF_MEMORY -->
- <!-- USE: TEMP_CLEAR -->

---
````
