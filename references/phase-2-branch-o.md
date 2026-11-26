---
id: phase-2-branch-o
scope: "PHASE 2 procedure template for Branch O (Ops & Infrastructure) -- generated when A1 = G"
read-when: "Phase 4 plan document generation, only when A1 = G selects Branch O"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, phase-2, branch-o, generation, category-b]
---

#### `.workflow-references/phase-2-execution.md` - Branch O (Ops & Infrastructure)

> Generated when **A1 = G**. Only one branch is generated per project.
> Fragment markers (`<!-- USE: X -->`) reference Shared Step Fragments defined
> in `agent-file-templates.md` and are expanded at generation time per the
> fragment expansion rule there. `[COMBINATION: secondary=<branch>]` blocks are
> included only when A1-combo selected that secondary branch; they contribute
> Step 5 QA checklist items only. The entry file carries a one-liner reference
> to the generated `.workflow-references/phase-2-execution.md`.

````markdown
[GENERATE WHEN A1 = G]:

# PHASE 2 - Ops & Infrastructure (SRE, Builder & Reviewer Modes)

> **Scope:** Complete PHASE 2 procedure. Read this file when entering
> PHASE 2 (Path A confirmed from PHASE 1, or bug fix routing to Step 4).

---

*Only enter if Path A was confirmed. Start as a cautious Infrastructure Lead -
blast-radius-aware, rollback-first, production-respectful.*

**Strict sequential execution:** complete each step fully before moving to
the next. Do not skip, reorder, or combine steps.

<!-- USE: CHANGE_LOG_INJECT -->

<!-- USE: CHECK_LADDER -->

**Step 1: Change Plan & Rollback Strategy.**
- Define the change scope: which resources, environments, and services are
  affected. State the desired end state in plain language.
- **Rollback strategy (mandatory):** document the rollback path BEFORE any
  change is applied. If rollback is not possible (destructive migration),
  state so explicitly and require user acknowledgment.
- Estimate risk (Low / Medium / High) and list prerequisites (credentials,
  environment access, approval gates, maintenance windows).
- **Documentation Preservation:** save the approved URD and PRD as files.
  Initialize `docs/change_plan.md` as a **living document**.

**Step 2: IaC / Config Authoring.**
- **Build in distinct stages.** Modules, resources, and config changes are
  authored one logical unit at a time.
- **Surgical Edits (BD-2):** every change traces to `docs/change_plan.md`.
- **Explain as you go.** Name the blast radius of each resource change.
- **Checkpoint:** stop before any resource that touches production data or
  networking.
- <!-- USE: SYNC_DOCS -->
- <!-- USE: PRODUCT_AI_READABILITY -->
- <!-- USE: VISUAL_PRESENTATION -->
[LOOP FIT = loop ONLY]:
- <!-- USE: RED_FIRST -->

**Step 3: Dry-Run & Plan Verification.**
- Run `plan` / `diff` / `dry-run` for every IaC tool in use (Terraform plan,
  Kubernetes diff, Ansible check mode, etc.).
- **Review the plan output line by line.** Flag unexpected additions,
  deletions, or replacements - especially anything involving data stores,
  networking, or IAM.
- Confirm the plan output matches `docs/change_plan.md` expectations.

**Step 4: Blast Radius Analysis & Rollback Path Verification.**
- **Blast radius audit:** list every resource the change touches, its
  downstream dependents, and the failure mode if the change goes wrong.
- **Rollback verification:** confirm the documented rollback path is still
  valid after the dry-run. If the plan reveals a rollback gap, stop and
  update the rollback strategy before proceeding.
- **Invalidated assumptions** (a resource that proved to have unexpected
  dependencies, an API that behaves differently than documented) are
  recorded in `MEMORY.md` Error Memory immediately.
- <!-- USE: SYNC_DOCS -->
- <!-- USE: MANDATORY_QA_TRANSITION -->

**Step 5: Staged Rollout QA & Monitoring Confirmation (Review Expert Mode) [CRITICAL].**
[LOOP FIT = loop ONLY]:
- <!-- USE: CHECK_EXECUTION -->
- *Trigger:* when dry-run passes and rollback path is verified.
- **Role Switch:** adopt the persona of a rigorous Change Review Board member.
- **Action 1 (Assemble):** start from the checks accumulated during Steps 2-4;
  from the change plan and dry-run output, add the whole-change items that
  could not run until now, covering: plan/diff output matches expectations,
  rollback path documented and tested, no unintended resource deletions,
  IAM/networking changes are least-privilege, secrets are not hardcoded,
  monitoring/alerting covers the changed resources.
- **Action 2 (Execution):** execute the checklist item by item.
  **Agent-verifiable:** plan/diff review, config lint, policy checks, rollback
  path analysis, secret scanning, IaC best-practice audit.
  **Inherently BLOCKED:** apply to production, post-apply health checks,
  production metrics validation, load testing, stakeholder sign-off.
  <!-- USE: BLOCKED_CLAUSE -->
- **Action 3 (Reporting):** save a review report as `docs/review_report.md`.
  Explicitly delineate the BLOCKED boundary: what was verified locally vs.
  what requires production access.
- **Action 4 (Fix & Verify):** switch back to Infrastructure Lead role, fix
  findings. Repeat until the locally-verifiable checklist passes.
  <!-- USE: LOOP_CAP -->
- **Product AI-readability:** domain-appropriate machine-readability checks
  per the PRODUCT_AI_READABILITY provisions in Step 2. Any check the agent
  cannot perform is marked BLOCKED.

[COMBINATION: secondary=S]:
- **Borrowed from Branch S QA:** test plan covers any supporting scripts or
  automation, browser-based verification of dashboards executed or BLOCKED.

[COMBINATION: secondary=D]:
- **Borrowed from Branch D QA:** citation integrity on referenced runbooks
  or architecture docs, factual accuracy spot-check.

**Step 6: Post-Change Verification & Runbook Update.**
- Provide the apply checklist (maintenance window, notification, apply
  command, post-apply health checks, monitoring dashboard links).
- After the user applies: update `docs/change_plan.md` with the actual
  outcome, update any runbooks affected by the change.
- Ensure `README.md` and `docs/` are complete and up to date.
- Suggest what could be improved or automated in the next iteration.
- <!-- USE: HANDOFF_MEMORY -->
- <!-- USE: TEMP_CLEAR -->
````
