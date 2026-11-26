# Workspace Workflow Builder - Prompt Design Spec

## Install

The skill needs `git` (see Compatibility & Dependencies). Pick the row for
your runtime:

| Runtime | Steps |
|---------|-------|
| Claude Code | Clone into your personal skills folder: `git clone https://github.com/Josh-Chung/workspace-workflow-builder ~/.claude/skills/workspace-workflow-builder`. For one project only, clone into that project's `.claude/skills/` instead |
| Claude app (claude.ai, desktop) | From a clone, build a ZIP whose root folder carries the skill's name: `git archive --format=zip --prefix=workspace-workflow-builder/ -o workspace-workflow-builder.zip HEAD`. Upload that ZIP under Skills in Claude's settings |
| Codex CLI, Antigravity, other single-file runtimes | Use `dist/SKILL_workspace_workflow_builder_single.md`, the whole skill in one file (see Cross-runtime support) |

The package's own checks are listed in `CHECKS` and run from the package
root: `sh tests/test_user_level_snippet.sh` and
`sh tests/test_elicitation_consumers.sh`. The Testing Summary also quotes
runs of `check-artifact.sh`, the A-check runner of the workspace this skill
is built in; that runner does not ship with the package.

License: MIT -- see `LICENSE`.

---

## Artifact Classification

- **Type:** C (Skill)
- **Delivery form:** `SKILL.md` package with progressive disclosure
- **Target runtimes:** Claude (Anthropic), Codex CLI (OpenAI),
  Antigravity (Google) -- single-file edition for non-Claude runtimes
- **Deployment language:** Bilingual (English + Chinese)

---

## Purpose & Success Criteria

### Goal

Provide a one-command skill that generates a complete, production-ready
AI agent workspace for any project type. The skill handles three modes:

- **Mode A (Bootstrap):** build a workspace from scratch
- **Mode B (Refactor):** analyze and restructure an existing workspace
- **Mode C (Home only):** set up only the user-level instruction files in the
  home folder -- personal defaults for every project -- with no workspace build

### Success Criteria

1. Generated files are immediately usable -- no manual assembly or
   placeholder filling required.
2. Every generated instruction package is fully self-contained (Method Y):
   the entry files `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` are byte-identical
   copies of one body, nothing references a file outside the package, and the
   text is pure ASCII.
3. The skill correctly prunes irrelevant questions via the conditional
   pruning matrix -- a solo documentation project is never asked about
   CI pipelines or CODEOWNERS.
4. Sandbox environments degrade gracefully (patch artifacts instead of
   blocking prompts).
5. Cross-runtime compatibility: the single-file edition works on Codex
   CLI and Antigravity without modification.

---

## Package Structure

```
skills/workspace-workflow-builder/
+-- SKILL.md                          # Main skill definition (process skeleton + decision gates)
+-- README.md                         # This file (Prompt Design Spec)
+-- CHECKS                            # Checks A11 runs: the two suites under tests/
+-- LICENSE                           # MIT
+-- references/
|   +-- environment-setup.md          # Appendix A: git install & recovery paths
|   +-- elicitation-questions.md      # Appendix B: question bank, Track A (A1-A6)
|   +-- elicitation-track-b.md        # Appendix C: question bank, Track B (B0-B10)
|   +-- project-file-templates.md     # Appendix D: Category A templates (directory, README, .gitignore)
|   +-- agent-file-templates.md       # Appendix E: Category B core (rules, fragments)
|   +-- entry-file-templates.md       # Appendix F: CLAUDE/AGENTS/GEMINI + phase-1-discovery
|   +-- memory-template.md            # Appendix G: MEMORY.md template
|   +-- change-logging-template.md    # Appendix H: Change Logging Rule block (A5 = C)
|   +-- phase-2-branch-templates.md   # Appendix I: branch index (routes A1 to one file)
|   +-- phase-2-branch-s|e|p|d|c|o.md # Appendices J-O: one PHASE 2 branch each
|   +-- git-workflow-template.md      # Appendix P: GIT_WORKFLOW.md Shared Core + Solo
|   +-- git-workflow-team.md          # Appendix Q: GIT_WORKFLOW.md Part C Team mode
|   +-- visual-presentation.md        # Appendix R: token + color + structure + display rules
|   +-- execution-steps.md            # Appendix S: Phase 5 steps + command quick reference
|   +-- print-output.md               # Appendix T: press-file font type, outlining, preflight
|   +-- user-level-files.md           # Appendix U: home-folder instruction files (U1-U2, Mode C)
+-- tests/
|   +-- test_user_level_snippet.sh    # Rung O: runs the shipped resolution + validation snippets on 35 fixtures
|   +-- test_elicitation_consumers.sh # Rung A: every question has a reader; 4 must-fail fixtures
+-- scripts/
|   +-- build-single-file.sh          # Concatenates SKILL.md + all references into single-file edition
+-- dist/
    +-- SKILL_workspace_workflow_builder_single.md   # Built single-file edition for non-Claude runtimes
```

### Progressive Disclosure Schedule

| When | File read |
|------|-----------|
| Phase 0, only if `git=missing` | `references/environment-setup.md` |
| Phase 3 entry, Track A | `references/elicitation-questions.md` |
| Phase 3, after Track A resolves | `references/elicitation-track-b.md` |
| Phase 1 when the mode is C (Home only); Phase 3 right after B0; Phase 4 and Phase 5 Step 3b, only when U1 != A | `references/user-level-files.md` |
| Phase 4, Category A generation | `references/project-file-templates.md` |
| Phase 4, Category B core + fragments | `references/agent-file-templates.md` |
| Phase 4, Category B entry files | `references/entry-file-templates.md` |
| Phase 4, when `MEMORY.md` is generated | `references/memory-template.md` |
| Phase 4, only when A5 = C | `references/change-logging-template.md` |
| Phase 4, Category B Phase 2 branches | `references/phase-2-branch-templates.md`, then one `phase-2-branch-<x>.md` |
| Phase 4, Category B git workflow | `references/git-workflow-template.md` (+ `git-workflow-team.md` for Team mode) |
| Phase 4, when the project's deliverables include visual output | `references/visual-presentation.md` |
| Phase 4, when any of that output is a press file (a PDF handed to a print shop) | `references/print-output.md` as well |
| Phase 5 entry | `references/execution-steps.md` |

---

## Workflow Phases

| Phase | Name | Purpose |
|-------|------|---------|
| 0 | Environment Pre-Check | Sandbox detection, tool availability, risk-tier classification |
| 1 | Mode Detection | Bootstrap (A) vs. Refactor (B) vs. Home only (C); Mode C then follows its own route in `references/user-level-files.md` |
| 2 | Existing Structure Capture | Mode B only -- scan, upload, or describe existing layout |
| 3 | Requirements Elicitation | Preset selection, bilingual question bank, conditional pruning, confirmation gate |
| 4 | Plan Document Generation | Category A (project files) + Category B (agent files) + Category C (user-level instruction files, only when U1 != A), user confirmation required |
| 5 | Execution | Risk-tiered file creation, modification, deletion with sandbox degradation |
| 6 | Sync Consistency Enforcement | Post-generation shared-content propagation across agent files |

---

## Elicitation Variables

Every question below must have a reader: a template or step that turns its
answer into output. `tests/test_elicitation_consumers.sh` fails on any
question in the two banks that no other reference file names -- B4, B8 and
B10 shipped unread until it existed. It proves presence only; whether each
option produces what it promises stays a J-check.

### Track A -- Project Context

| Variable | Question | Options |
|----------|----------|---------|
| A1 | Project type & tech stack | Software / Data & ML / Prompt & Agent / Documentation / Content / Ops & Infra / Other |
| A2 | Team scale | Solo / Small (2-5) / Medium (6-20) / Large (20+) |
| A3 | CI/CD platform | None / GitHub Actions / Other / Undecided |
| A4 | Branch strategy | GitHub Flow / Git Flow / Trunk-based / Custom |
| A5 | Change logging | None / Manual / Agent-maintained |
| A6 | Agent file tracking | Exclude from git / Track all / Selective |

### Track B -- Agent Architecture

| Variable | Question | Options |
|----------|----------|---------|
| B0 | Agent selection | Claude only / Gemini only / Codex only / Multiple agents |
| B1 | Claude config | Higher reasoning effort / MCP tools / Both / Neither |
| B2 | Memory strategy | Session-only / Persistent / Hybrid / No memory |
| B3 | Memory categories | Basic 4 / + shared / + shared + private |
| B4 | Multi-agent division of work | One lead writes, the others read and report / Split by domain / Sequential handoff / Orchestration framework (decision record only) / Custom |
| B5 | Agent-Git ownership | None / Single agent drafts / Split roles / Custom |
| B6 | GIT_WORKFLOW.md scope | Basic / + merge + PR / + CODEOWNERS + protection / Full governance |
| B7 | Failure strategy | Silent fail & log / Pause & ask / Human-directed fallback / Custom |
| B8 | Audit level | None / Lightweight / Structured / Full trail |
| B9 | Memory cleanup | Event-driven / Event + time window / Event + iteration review / Custom |
| B10 | Rule enforcement | All prose-level / Mark absolutes + name a mechanism / + wiring checklist / Custom |

### Add-on -- User-level Instruction Files

Asked right after B0, whatever B0 chose; every preset defaults U1 to A, so
the add-on never runs unless the user opts in. In Mode C, U1 is the first
question and has no option A.

| Variable | Question | Options |
|----------|----------|---------|
| U1 | User-level instruction file in the home folder | No / Yes, one or more of: Claude `~/.claude/CLAUDE.md`, Codex `$CODEX_HOME/AGENTS.md`, Gemini `~/.gemini/GEMINI.md` (Gemini CLI and Antigravity CLI), Other (runtime and path named by the user, written only if it is a plain Markdown file loaded whole) |
| U2 | Personal-defaults content | Profile + communication / + cross-project habits / Custom |

### Preset Profiles

| Preset | Remaining required questions |
|--------|------------------------------|
| Solo-Lite | A1, B0, B1 (if Claude) |
| Team-Standard | A1, B0, B1 (if applicable), B4 (if multi-agent), B5, B10 follow-up (existing guarantees) |
| Enterprise-Full | Same as Team-Standard + A3 platform confirmation |
| Custom | Full bank (pruning matrix still applies) |

---

## Template Branch Selection (A1-driven)

| A1 value | Branch | PHASE 2 focus |
|----------|--------|---------------|
| A (Software) | S - Engineering | Capability-gated sub-agent delegation, QA loops, living documentation |
| B/C (Data & ML) | E - Data & Experiment | Experiment tracking, notebook workflow, model registry |
| D (Documentation) | D - Document & Research | Source management, review cycles, capability-gated sub-agent source checks, publication pipeline |
| E (Content) | C - Content Operations | Editorial workflow, publishing cadence, multi-channel |
| F (Prompt & Agent) | P - Prompt & Agent Engineering | Prompt versioning, evaluation loops, artifact taxonomy |
| G (Ops & Infra) | O - Ops & Infrastructure | Runbooks, incident response, IaC drift detection |
| H (Other) | One clarifying question to map to nearest branch |

---

## Trigger Matrix

### Should-trigger phrasings

1. "set up my project structure"
2. "build workspace"
3. "scaffold my project"
4. "create CLAUDE.md and AGENTS.md"
5. "set up AI agent files"
6. (Chinese) "搭建工作目录"
7. (Chinese) "初始化项目结构"
8. (Chinese) "配置 AI Agent 工作流"
9. "organize my workspace for AI agents"
10. "refactor my project structure"
11. (Chinese) "重构项目结构"
12. (Chinese) "改造工作目录"
13. "set up user-level instruction files" (Mode C)
14. "set my personal defaults in ~/.claude/CLAUDE.md and ~/.gemini/GEMINI.md" (Mode C)
15. (Chinese) "设置用户级指令文件" (Mode C)

### Should-NOT-trigger phrasings

1. "edit CLAUDE.md line 42" (isolated file edit)
2. "create a new Python file" (single-file creation)
3. "git merge my branch" (pure git operation)
4. "set up ESLint" (tool config unrelated to project structure)
5. "fix the bug in auth.py" (code task)
6. (Chinese) "合并本地分支" (local git merge)
7. (Chinese) "修改 MEMORY.md" (isolated file edit)
8. "add one line to my ~/.claude/CLAUDE.md" (isolated file edit, done directly)
9. "what is in my global GEMINI.md?" (a question, not a setup)

### Disambiguation question

When intent is ambiguous (e.g. "help me organize things"), the description
asks the two-way question below; Phase 1 then asks the three-way one, Mode C
included, whenever the mode is still unclear.

> "您是想从零构建工作目录结构，还是改造现有的项目工作流？ /
>  Are you looking to build a new workspace from scratch, or refactor
>  an existing one?"

---

## Compatibility & Dependencies

### Required tools

| Tool | Condition |
|------|-----------|
| `git` | Conditional -- required when deliverables include git workflow content; optional for documentation/content projects |

### Optional tools (silent fallback)

| Tool | Fallback |
|------|----------|
| `tree` | `find`-based directory listing |
| `gh` | Skip branch protection checks; note omission |
| `jq` | Plain text parsing |

### Cross-runtime support

The single-file edition (`dist/SKILL_workspace_workflow_builder_single.md`)
is built by `scripts/build-single-file.sh`. It concatenates `SKILL.md` with
all reference files as appendices, producing a self-contained prompt for
platforms that consume a single file (Codex CLI, Antigravity). Pointer lines
in the body ("read `references/<file>.md`") map to the appendix of the same
title.

---

## Sandbox Behavior

| Risk tier | Non-sandbox | Sandbox / CI |
|-----------|-------------|--------------|
| Low (new dirs, new files) | Auto-execute | Auto-execute |
| Medium (modify existing) | Diff + confirm | Emit patch file + apply instructions |
| High (delete, overwrite) | Per-item confirmation | Hard stop + user instructions |
| Home (U1 user-level instruction files, outside the workspace) | Full diff + per-file confirmation, even for a new file | Never written: emit `user-level-personal-defaults.proposed.md` + next-step instructions |
| Prohibited (network, OAuth, cross-repo, any other write outside the workspace) | N/A | Permanently prohibited |

---

## Design Decisions

| Decision | Rationale | Alternatives considered |
|----------|-----------|------------------------|
| Progressive disclosure (multi-file) | Keeps each phase's context window focused; reference files are read only when needed | Monolithic SKILL.md (too large for reliable context retention) |
| Single-file edition via build script | Cross-runtime compatibility without maintaining two source copies | Manual copy-paste (error-prone, drift risk) |
| Preset profiles with override | Reduces question count from 15+ to 2-3 for common cases while preserving full customization | Fixed profiles without override (too rigid); no presets (too many questions for simple projects) |
| Bilingual (EN + ZH) questions | Primary user base includes Chinese speakers; bilingual phrasing also serves as trigger coverage | English-only (excludes target users); separate localized editions (maintenance burden) |
| Method Y (full self-containment) | Generated agent files must work independently per runtime; no cross-file references between parallel entry files | DRY references between files (breaks when only one file is loaded) |
| Conditional pruning matrix | Prevents irrelevant questions (solo project never asked about CODEOWNERS); resolution is auditable in confirmation summary | Skip silently (user cannot verify what was assumed); always ask everything (wastes time) |
| ASCII invariant for instruction files | Machine-detectable corruption; safe across all runtimes and editors | UTF-8 everywhere (invisible corruption risk from BOM, curly quotes, em dashes) |
| User-level instruction files as an opt-in add-on carrying personal defaults only | A user-level instruction file loads in every project alongside each project file, and the runtime resolves a contradiction arbitrarily -- so it holds only what is true everywhere, and the project files stay complete without it | Copy the generic rules (Core Operating Rules, BD-1 to BD-6) home too (loads them twice per turn and counts toward the Codex 32 KiB cap) |
| Mode C (Home only): the user-level files with no workspace build | The home file belongs to the machine, not to one project, so changing it should not need a workspace build. Rejected on 2026-11-24 for its trigger cost; adopted 2026-11-25 once the description had room (980 of 1024 characters) | A separate skill (would copy the ~27 KB module, two copies to keep in step); the add-on only (a personal-defaults change needs a full workspace run) |
| Gemini as a verified target, `~/.gemini/GEMINI.md` | Gemini CLI and Antigravity CLI both read that file, so one target covers both; every fact is sourced (docs, and Gemini CLI's source for `GEMINI_CLI_HOME` and the memory tool) | Leave Gemini out (B0 offered it for project files while U1 did not); separate Gemini CLI and Antigravity targets (the same file twice) |
| Other runtimes: the user states the path, a write gate decides, an O-check proves it | The skill makes no network request, so it cannot look a runtime up; facts it cannot verify come from the user, labeled unverified, and only the runtime itself showing the block counts as proof. A file the runtime does not load whole (a settings screen, a frontmatter rules folder) gets the paste file instead | Write any path given (a settings screen or a frontmatter folder would silently ignore it); refuse other runtimes (the question that started this) |
| The block goes before `## Gemini Added Memories` | Gemini CLI's older `save_memory` (read at v0.1.22 and v0.5.5) ends that section at the next `## ` line, so a block after the heading would get the next saved fact inside its markers, and a rerun would delete it | Append at the end as for other files (the failure above) |
| A marked block, never a whole-file write | Users already keep their own text in these files; markers make a rerun replace its own block, and Claude Code strips the comment markers before loading | Overwrite the file (destroys user content); append without markers (a rerun duplicates the block) |
| No `<repo>/.codex/AGENTS.md` placement | Codex reads project `AGENTS.md` only from the project root down to the working directory; a file there would never load | Offer it anyway (a silent no-op); point Codex at it via `model_instructions_file` (replaces Codex's built-in instructions rather than adding to them) |

---

## Known Limitations

- **BLOCKED (Requires User Verification):** branch protection API calls
  (`gh api repos/.../protection`) require authenticated `gh` with appropriate
  permissions. Cannot be verified in sandbox or unauthenticated environments.
- **BLOCKED (Requires User Verification):** CODEOWNERS syntax validation
  via `gh api` requires repo write access.
- **Reproduction for both BLOCKED items:** run `gh auth status` to confirm an
  authenticated account with repo write access, then
  `gh api repos/<owner>/<repo>/branches/<branch>/protection` and
  `gh api repos/<owner>/<repo>/codeowners/errors`. Until the user reports the
  result both stay BLOCKED -- never downgraded to PASS.
- **BLOCKED (Requires User Verification):** whether each runtime actually
  loads a user-level instruction file (U1 != A). Reproduction: in a new Claude
  Code session run `/context all` and look for the home `CLAUDE.md` under
  "Memory files"; for Codex run
  `codex --ask-for-approval never "Summarize the current instructions."` and
  look for the block's "Working language" line; in a new Gemini CLI session
  run `/memory show` and look for that line; in Antigravity CLI run
  `/context` and look for the target's path; for an Other runtime, ask it in
  a new session what its instructions say about the working language, or use
  its own command that lists loaded files. The written block itself is
  A-checked by the snippets in `references/user-level-files.md`, and the
  snippets are held to 35 fixture cases, must-fail cases included, by
  `tests/test_user_level_snippet.sh`, which A11 runs through `CHECKS`.
- Facts the docs do not state stay questions, never assumptions: whether
  `CLAUDE_CONFIG_DIR` moves the user-level `CLAUDE.md`; which global names
  Gemini CLI loads when `context.fileName` is set; whether Antigravity honours
  `GEMINI_CLI_HOME`. The skill asks, and the O-check settles each one.
- An Other runtime's path and loading are user-stated and unverified until
  its O-check passes; the skill ships no facts for it and looks none up.
- `tests/test_elicitation_consumers.sh` covers the two question banks only.
  U1 and U2 live in `references/user-level-files.md`, which both asks and
  reads them, so that test cannot see them.
- The single-file edition must be rebuilt manually after any change to
  `SKILL.md` or reference files (`sh scripts/build-single-file.sh`). This is
  no longer only a convention: `dist/` is tracked, and the dist-freshness
  A-check rebuilds and compares, so a bundle that lags its sources fails
  rather than passing unnoticed.
- Git Flow and Trunk-Based Development branch strategy templates (A4 = B/C)
  contain generation directives rather than fully pre-written content --
  the generating agent must compose the detail from the directive.

---

## Testing Summary -- User-level Runtimes and Mode C (2026-11-25)

Loop verdict: **loop**. The resolution and validation snippets have values
statable in advance (paths, marker state, byte counts), a shell settles them
in seconds, and Step 3b re-composes after a failed check.

| Check | Rung | Result |
|---|---|---|
| `tests/test_user_level_snippet.sh` | O | 35 passed, 0 failed. Red first: before the module change, 17 of the 35 failed -- e.g. `FAIL  18 third block differs -> got pass (want fail)` and `FAIL  28 user's blank line lost -> got pass (want fail)`; 28 shows the old snippet missed a lost blank line at the seam |
| `tests/test_elicitation_consumers.sh` | A | exits 0 (A11); it cannot see U1/U2 -- Known Limitations |
| `sh scripts/check-artifact.sh skills/workspace-workflow-builder` | A | PASS -- A2-A15 ok, A1 skipped (a skill has no `AGENTS.md`) |
| Description length | A | 980 of 1024 characters (A7) |
| Mode C walk-through from `SKILL.md` (Phase 1 pointer -> Mode C route -> Step 3b -> validation), Modes A/B with a target B0 did not select, and each Gemini fact against its source | J | author's own context: complete; one gap found and fixed (U1's "Also" wording read oddly as Mode C's first question) |
| Trigger shape: Mode C phrases 13-15 sit in the description, near-misses 8-9 fall under its DO NOT clause | J | author's own context. Risk noted: "setting up user-level instruction files excepted" could pull in a one-line edit to a home file; the wording names setting up, not editing |
| Mode C triggers fire live | J | BLOCKED (Requires User Verification). Reproduction: in a new Claude Code session with this skill installed, send each Trigger Matrix phrase 13-15 and near-miss 8-9 on its own; the skill should load for 13-15 only. Stays BLOCKED until the user reports the five results |
| Each runtime loads its user-level file | O | BLOCKED (Requires User Verification) -- reproduction in Known Limitations |

---

## Iteration Suggestions

- Add eval scripts (`evals/`) with synthetic user profiles to test
  pruning-matrix correctness and preset-to-output fidelity.
- Extend `references/change-logging-template.md` (which now holds the A5=C
  Change Logging Rule block) with integration patterns that differ by project
  type -- the block itself is currently one-size-fits-all.
- Explore auto-rebuild of the single-file edition via a git pre-commit
  hook or CI step.
- Add a Phase 7 (Validation) that runs the generated agent files through
  a lightweight self-test (e.g. check Method Y compliance, ASCII invariant,
  internal cross-references).
