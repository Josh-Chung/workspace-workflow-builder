---
id: phase-2-branch-e
scope: "PHASE 2 procedure template for Branch E (Data & Experiment) -- generated when A1 = B/C"
read-when: "Phase 4 plan document generation, only when A1 = B/C selects Branch E"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, phase-2, branch-e, generation, category-b]
---

#### `.workflow-references/phase-2-execution.md` - Branch E (Data & Experiment)

> Generated when **A1 = B/C**. Only one branch is generated per project.
> Fragment markers (`<!-- USE: X -->`) reference Shared Step Fragments defined
> in `agent-file-templates.md` and are expanded at generation time per the
> fragment expansion rule there. `[COMBINATION: secondary=<branch>]` blocks are
> included only when A1-combo selected that secondary branch; they contribute
> Step 5 QA checklist items only. The entry file carries a one-liner reference
> to the generated `.workflow-references/phase-2-execution.md`.

````markdown
[GENERATE WHEN A1 = B/C]:

# PHASE 2 - Data & Experiment Delivery (Analyst, Scientist & Reviewer Modes)

> **Scope:** Complete PHASE 2 procedure. Read this file when entering
> PHASE 2 (Path A confirmed from PHASE 1, or bug fix routing to Step 4).

---

*Only enter if Path A was confirmed. Start as a rigorous Research Lead -
hypothesis-driven, transparent about uncertainty, reproducibility-focused.*

**Strict sequential execution:** complete each step fully before moving to
the next. Do not skip, reorder, or combine steps.

<!-- USE: CHANGE_LOG_INJECT -->

<!-- USE: CHECK_LADDER -->

**Step 1: Hypothesis & Experiment Design.**
- State the research question or hypothesis in falsifiable form.
- Propose the experiment plan: datasets, features, baselines, evaluation
  metrics, and success thresholds - in plain language.
- Estimate scope (Simple / Medium / Ambitious) and list prerequisites
  (data access, compute, API keys, labelled ground truth).
- **Documentation Preservation:** save the approved URD and PRD as files in
  the project directory. Initialize `docs/experiment_log.md` as a **living
  document** recording every experiment run (date, config, result, decision).

**Step 2: Exploratory Analysis & Prototyping.**
- **Explore data before modelling.** Summary statistics, distributions,
  missing-value audit, class balance, and leakage checks come first.
- **Build in distinct stages.** Do not dump one massive notebook unless asked.
- **Surgical Edits (BD-2):** every cell or script traces to the experiment
  plan or the current exploration goal.
- <!-- USE: CLAIMS_DISCIPLINE -->
- **Checkpoint:** stop at key decision points (feature selection, model
  family, train/val/test split strategy).
- <!-- USE: SYNC_DOCS -->
[LOOP FIT = loop ONLY]:
- <!-- USE: RED_FIRST -->

**Step 3: Experiment Execution.**
- Run experiments per the plan. Log every run to `docs/experiment_log.md`:
  config hash, hyperparameters, metric values, wall-clock time.
- **Reproducibility discipline:** fix random seeds, pin dependency versions,
  record data version or snapshot hash. A result that cannot be reproduced
  is not a result.
- **Negative results are results.** Record what did not work and why in the
  experiment log; do not silently discard failed runs.

**Step 4: Statistical Error Investigation.**
- **Check for data leakage:** verify no test-set information leaks into
  training features, preprocessing, or feature selection.
- **Baseline fairness:** confirm the baseline is a fair comparison (same
  data split, same preprocessing, same evaluation protocol).
- **Overfitting audit:** compare train vs. validation vs. test metrics;
  flag suspiciously large gaps.
- **Irreproducibility triage:** if metrics shift across reruns beyond
  expected variance, investigate before declaring a winner.
- **Invalidated assumptions** (a dataset that proved biased, a metric that
  does not capture the goal) are recorded in `MEMORY.md` Error Memory
  immediately.
- <!-- USE: SYNC_DOCS -->
- <!-- USE: MANDATORY_QA_TRANSITION -->

**Step 5: Metrics Validation & Reproducibility QA (Review Expert Mode) [CRITICAL].**
[LOOP FIT = loop ONLY]:
- <!-- USE: CHECK_EXECUTION -->
- *Trigger:* when experiments are complete and a candidate model/pipeline is
  selected.
- **Role Switch:** adopt the persona of a rigorous peer reviewer.
- **Action 1 (Assemble):** start from the checks accumulated during Steps 2-4;
  from the PRD and experiment log, add the whole-experiment items that could
  not run until now, covering: holdout metric evaluation (never on train or
  val), statistical significance or confidence intervals where applicable,
  reproducibility (re-run from clean state with documented seeds), data
  version pinned, no data leakage, baseline comparison fair, and experiment
  log complete.
- **Action 2 (Execution):** execute the checklist item by item.
  **Branch E blocked examples:** production-scale data validation, GPU cluster
  re-runs, A/B test deployment, domain-expert judgment on feature relevance.
  <!-- USE: BLOCKED_CLAUSE -->
- **Action 3 (Reporting):** save a review report as `docs/review_report.md`.
- **Action 4 (Fix & Verify):** switch back to analyst role, fix findings,
  update experiment log. Repeat the review loop until the checklist passes.
  <!-- USE: LOOP_CAP -->

[COMBINATION: secondary=S]:
- **Borrowed from Branch S QA:** test plan covers all pipeline scripts and
  automation, browser-based verification executed or BLOCKED.

[COMBINATION: secondary=D]:
- **Borrowed from Branch D QA:** citation integrity on all referenced papers
  and datasets, factual accuracy spot-check, cross-version parity.

**Step 6: Report & Experiment Log.**
- Deliver the final analysis report with methodology, results, and
  limitations clearly stated.
- Ensure `docs/experiment_log.md` is complete - every run that informed the
  final decision is documented.
- Ensure `README.md` and `docs/` are complete and up to date.
- Suggest what could be added or improved in the next iteration.
- <!-- USE: HANDOFF_MEMORY -->
- <!-- USE: TEMP_CLEAR -->

---
````
