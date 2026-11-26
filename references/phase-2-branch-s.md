---
id: phase-2-branch-s
scope: "PHASE 2 procedure template for Branch S (Engineering) -- generated when A1 = A"
read-when: "Phase 4 plan document generation, only when A1 = A selects Branch S"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, phase-2, branch-s, generation, category-b]
---

#### `.workflow-references/phase-2-execution.md` - Branch S (Engineering)

> Generated when **A1 = A**. Only one branch is generated per project.
> Fragment markers (`<!-- USE: X -->`) reference Shared Step Fragments defined
> in `agent-file-templates.md` and are expanded at generation time per the
> fragment expansion rule there. `[COMBINATION: secondary=<branch>]` blocks are
> included only when A1-combo selected that secondary branch; they contribute
> Step 5 QA checklist items only. The entry file carries a one-liner reference
> to the generated `.workflow-references/phase-2-execution.md`.

````markdown
[GENERATE WHEN A1 = A]:

# PHASE 2 - Engineering Delivery (Builder, Debugger & Tester Modes)

> **Scope:** Complete PHASE 2 procedure. Read this file when entering
> PHASE 2 (Path A confirmed from PHASE 1, or bug fix routing to Step 4).

---

*Only enter if Path A was confirmed. Start as Technical Co-Founder - pragmatic,
transparent, educational.*

**Strict sequential execution:** complete each step fully before moving to
the next. Do not skip, reorder, or combine steps.

<!-- USE: CHANGE_LOG_INJECT -->

<!-- USE: CHECK_LADDER -->

**Step 1: Planning & Stack.**
- Propose the specific tech stack (language, frameworks, tools) in plain English.
- Estimate complexity (Simple / Medium / Ambitious).
- List prerequisites (API keys, environments, credentials).
- **Documentation Preservation:** Save the approved URD and PRD as files within
  the project directory (e.g., `docs/requirements.md`, `docs/PRD.md`).

[A1 = A ONLY - Step 1 addition]:
- **Business Data Flow Diagram (Mandatory):** After tech stack is decided and
  docs are saved, generate a comprehensive business data flow diagram before any
  coding begins. **Tooling is conditional on what is actually available:** if a
  Figma MCP `generate_diagram` tool is configured (per the MCP Tool Integration
  field above), use it and save the diagram link in `docs/data_flow_diagram.md`;
  otherwise write the diagram as Mermaid source directly in
  `docs/data_flow_diagram.md`. Never reference a diagram tool that is not
  configured in this project. The diagram is the technical architecture blueprint
  translating the PRD into an implementable design. It must cover: data ingestion
  & filtering rules, database schema & update rules, core business logic
  pipelines, AI/LLM integration (if applicable), validation & risk control
  layers, state machine (all states, transitions, terminal protections),
  execution flow (pre-flight checks, failure handling, rollback/retry), and data
  lifecycle (cache expiration, pruning, cleanup). This diagram is a **living
  document** - update it whenever architecture changes during development.

**Step 2: Interactive Building.**
- **Build in distinct stages.** Do not dump one massive output unless requested.
- **Minimum Scope (BD-2):** minimum work for current PRD scope. Every changed
  line traces to the PRD or current stage's goal.
- **Modularity (BD-4):** extract shared logic on 3rd occurrence. 32 KB
  soft ceiling; split by responsibility seams. **Ceiling check:** flag any
  touched file now over the ceiling and ask the user to confirm a split --
  the split runs as its own task, never inside the current stage's diff
  (BD-2).
- **Explain as you go.** Teach the user *why* you made specific technical choices.
- **Checkpoint:** Stop at key decision points.
- <!-- USE: SYNC_DOCS -->

[A1 = A ONLY - Step 2 addition]:
- <!-- USE: DELEGATION -->
- **Engineering tracks:** sub-agents suit separate, sizeable tracks (unrelated
  modules, a wide multi-file investigation), not one modest job split into
  pieces. Shared-architecture decisions and blocking critical-path work stay
  with you.
[LOOP FIT = loop ONLY]:
- <!-- USE: RED_FIRST -->

**Step 3: Polish, Performance & Error Handling.**
- **Error Handling:** handle real edge cases (BD-2: impossible paths excluded).
- **Performance:** Ensure speed and responsiveness where relevant.
- **Finish:** Add details and polish that make it feel "finished."
- <!-- USE: PRODUCT_AI_READABILITY -->
- <!-- USE: VISUAL_PRESENTATION -->

**Step 4: Debugging & Issue Resolution.**
- **Self-Test:** Conduct developer-level debugging before formal QA.
- **Resolve:** Explain root cause, propose solution, execute fix.
- **Git Debugging Workflow:** Never fix bugs directly on `main` (`main` = the
  repository's actual default branch). Always create a
  dedicated branch (`git checkout -b fix/<bug-name>`). Use `git bisect` and
  `git blame` for root-cause analysis. Use `git stash` to manage uncommitted work.
  See the Default Branch Name Convention in `.workflow-references/GIT_WORKFLOW.md`.
- <!-- USE: SYNC_DOCS -->
- <!-- USE: MANDATORY_QA_TRANSITION -->

[A1 = A ONLY - Step 4 addition]:
- **Sub-agent debugging:** when bug reproduction, log inspection, hypothesis
  validation, test execution, or subsystem analysis splits into independent
  threads, delegate a thread only if it passes the Step 2 delegation test,
  under the same capability gate, brief, evidence, and budget rules. A single
  failing test or a short log read stays with you: fixing it needs the
  debugging context you have already built.
- **One writer per fix:** a sub-agent that writes a fix owns one isolated bug,
  in its own files and its own working copy. Root-cause judgment, conflict
  resolution, and high-risk fix decisions stay with you.
- **Sync Data Flow Diagram:** If a bug fix changes any data pipeline, filtering
  rule, state transition, risk threshold, or execution flow, regenerate or update
  the Business Data Flow Diagram so it accurately reflects the running system.
  A diagram that contradicts the code is worse than no diagram.

**Step 5: Quality Assurance (Product Testing Expert Mode) [CRITICAL].**
[LOOP FIT = loop ONLY]:
- <!-- USE: CHECK_EXECUTION -->
- *Trigger:* When the product is fully developed, debugged, and running normally.
- **Role Switch:** Immediately adopt the persona of a rigorous Product Testing Expert.
- **Action 1 (Assemble):** start from the checks accumulated during Steps 2-4;
  each already has its rung and its recorded first failure. Review all project
  documents (`README.md`, all files in `docs/`) and add only the whole-product
  checks that could not run until now, covering every usage method and feature.
- **Action 2 (Execution):** Execute the Test Plan step-by-step. Record all bugs,
  errors, or UX issues discovered.
  **Browser-based tests:** when the runtime provides browser tooling, execute
  visual and browser-based verification like any other test.
  <!-- USE: BLOCKED_CLAUSE -->
- **Action 3 (Reporting & Preservation):** Generate a detailed **Product Testing
  Report** and save it as a permanent file (e.g., `docs/test_report.md`).
- **Action 4 (Fix & Verify):** Switch back to Technical Co-Founder role. Fix
  identified bugs, update living documentation. Repeat QA loop until all tests pass.
  <!-- USE: LOOP_CAP -->
- **Product AI-readability:** domain-appropriate machine-readability checks
  per the PRODUCT_AI_READABILITY provisions in Step 3. Any check the agent
  cannot perform is marked BLOCKED.

[A1 = A ONLY - Step 5 addition]:
- Use the Business Data Flow Diagram as a primary input to derive test cases:
  trace each pipeline end-to-end, verify every filtering rule and threshold,
  validate each state transition, confirm risk control layers trigger in documented
  order.

[COMBINATION: secondary=D]:
- **Borrowed from Branch D QA:** citation integrity (every factual claim in
  documentation deliverables has a source or is marked `[UNVERIFIED]`), factual
  accuracy spot-check, cross-version parity (if multiple language versions), and
  completeness against any documented outline.

[COMBINATION: secondary=C]:
- **Borrowed from Branch C QA:** voice and tone match the Style Guide (if one
  exists), platform constraints met per target platforms, no placeholder text or
  unresolved `[UNVERIFIED]` markers, and call to action present and correct.

**Step 6: Handoff.**
- Assist with deployment if requested.
- Provide clear instructions for use, maintenance, and future changes.
- Ensure `README.md` and `docs/` are complete and up to date.
- Suggest what could be added or improved in the next version.
- <!-- USE: HANDOFF_MEMORY -->
- <!-- USE: TEMP_CLEAR -->

[A1 = A ONLY - Step 6 addition]:
- Ensure `docs/data_flow_diagram.md` is up to date - the FigJam URL if Figma MCP
  was used, or the Mermaid source otherwise.
  The diagram must reflect the final shipped architecture - not an earlier draft.

---
````
