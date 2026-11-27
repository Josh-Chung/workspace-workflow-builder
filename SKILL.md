---
name: workspace-workflow-builder
description: >
  Use this skill to build a workspace workflow from scratch, refactor an existing one,
  or set up only the user-level instruction files.
  Triggers: "set up my project structure", "build workspace", "scaffold my project",
  "organize my workspace", "set up AI agent files", "create CLAUDE.md", "create AGENTS.md",
  "set up MEMORY.md", "set up GIT_WORKFLOW.md", "set up user-level instruction files",
  "搭建工作目录", "初始化项目结构", "创建工作流文件", "配置 AI Agent 工作流", "重构项目结构",
  "改造工作目录", "设置用户级指令文件", or any intent to establish or refactor a project's
  directory structure and AI agent workflow files.
  DO NOT trigger for isolated file edits, single-file creation, pure git operations,
  or requests that only affect a specific tool config unrelated to project-wide structure
  -- setting up user-level instruction files excepted.
  When intent is ambiguous (e.g. "help me organize things"), ask:
  "您是想从零构建工作目录结构，还是改造现有的项目工作流？ /
   Are you looking to build a new workspace from scratch, or refactor an existing one?"
compatibility:
  required:
    - git
  optional:
    - tree (for directory visualization)
    - find (for filesystem scanning)
    - gh (GitHub CLI, for CODEOWNERS and branch protection checks)
    - jq (for structured output parsing)
---

# Workspace Workflow Builder

An AI Product Team skill for building or refactoring complete project
workspace workflows. Strictly two-phase: **understand and define** (Product
Manager mode - clarify needs, generate URD/PRD, confirm with user), then
**design and build** (Technical Co-Founder mode - directory structure, file
templates, workflow standards, fully populated AI Agent workflow files).

Generated Agent workflow files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`,
`MEMORY.md`, `GIT_WORKFLOW.md`, and companions) are tailored to the project
type and team's actual needs, embedding the full behavioral discipline,
two-phase workflow, and - for software projects - the complete technical
execution process (capability-gated sub-agent delegation, QA loops, living documentation).

`CLAUDE.md` / `AGENTS.md` / `GEMINI.md` / `GIT_WORKFLOW.md` are pure ASCII
and read-only to the working agent after initialization. `MEMORY.md` is the
agent's only self-writable file, organized as four parallel categories
(Project Memory / Decision Memory / Error Memory / Operational Specification
Rules).

---

> **Module layout (progressive disclosure):** this SKILL.md holds the full
> process skeleton and all decision gates. Detailed content lives in reference
> files - read each one only at the phase that needs it. In the single-file
> edition (built by `scripts/build-single-file.sh`), the same content appears
> as appendices at the end of this document under identical titles.

| When | Read |
|---|---|
| Phase 0, only if `git=missing` | `references/environment-setup.md` (Appendix A) |
| Phase 3 entry, Track A | `references/elicitation-questions.md` (Appendix B) |
| Phase 3, after Track A resolves | `references/elicitation-track-b.md` (Appendix C) |
| Phase 1 when the mode is C (Home only); Phase 3 right after B0; Phase 4 and Phase 5 Step 3b, only when U1 != A | `references/user-level-files.md` (Appendix U) |
| Phase 4, Category A generation | `references/project-file-templates.md` (Appendix D) |
| Phase 4, Category B core + fragments | `references/agent-file-templates.md` (Appendix E) |
| Phase 4, Category B entry files | `references/entry-file-templates.md` (Appendix F) |
| Phase 4, when `MEMORY.md` is generated | `references/memory-template.md` (Appendix G) |
| Phase 4, only when A5 = C | `references/change-logging-template.md` (Appendix H) |
| Phase 4, Category B Phase 2 branches -- index, then **one** branch file | `references/phase-2-branch-templates.md` (Appendix I) |
| Phase 4, the selected branch only | `references/phase-2-branch-<s/e/p/d/c/o>.md` (Appendices J-O) |
| Phase 4, Category B git workflow | `references/git-workflow-template.md` (Appendix P) |
| Phase 4, Team mode only | `references/git-workflow-team.md` (Appendix Q) |
| Phase 4, when the project's deliverables include visual output | `references/visual-presentation.md` (Appendix R) |
| Phase 4, when any of that output is a press file (a PDF handed to a print shop) | `references/print-output.md` (Appendix T) as well |
| Phase 5 entry | `references/execution-steps.md` (Appendix S) |

---

## Phase 0 - Environment Pre-Check

### ⚠️ CRITICAL: Sandbox Detection & Execution Rules

Before any file operation, detect the runtime environment. Check **actual runtime
state indicators**, not configuration files.

```bash
# Check for sandbox/CI environment indicators
echo "CI=${CI:-unset}"
echo "GITHUB_ACTIONS=${GITHUB_ACTIONS:-unset}"
echo "CODEX_SANDBOX=${CODEX_SANDBOX:-unset}"
ls /.dockerenv 2>/dev/null && echo "dockerenv=present" || echo "dockerenv=absent"
echo "HOME=$HOME"
```

**Sandbox Classification Rules:**

| Indicator | Condition | Classification |
|---|---|---|
| `CI=true` or `GITHUB_ACTIONS=true` | Any value set | Sandbox |
| `CODEX_SANDBOX=true` | Any value set | Sandbox |
| `/.dockerenv` exists | File present | Sandbox |
| `HOME=/home/sandbox` | Exact path match | Sandbox |
| `HOME=/root` | Linux root user | ⚠️ NOT a sandbox - do not false-positive |
| None of the above | - | Local / Non-sandbox |

### Tiered Permission Control (Risk-Stratified)

All file operations in this skill are governed by the following risk tiers,
applied dynamically regardless of mode:

| Risk Level | Operation Types | In Sandbox | Non-Sandbox |
|---|---|---|---|
| 🟢 **Low** | Create new directories, write new files (no prior content) | Auto-execute | Auto-execute |
| 🟡 **Medium** | Modify existing files, rename directories | Interactive: diff → confirm. Non-interactive (CI): do NOT write - emit a patch file + apply instructions | Display diff → require confirmation |
| 🔴 **High** | Delete files/directories, overwrite existing files | Hard stop → provide user instructions | Forced step-by-step confirmation per item |
| 🟠 **Home** | Write a user-level instruction file chosen in U1 (e.g. `~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`) - outside the workspace, loaded in every project | Never write: emit `user-level-personal-defaults.proposed.md` + next-step instructions | Full diff → per-file confirmation, even for a new file |
| 🚫 **Prohibited** | External network requests, OAuth flows, cross-repo operations, any write outside the workspace except the U1 user-level instruction files (🟠 Home) | Permanently prohibited | N/A |

> **Non-interactive rule:** A sandbox/CI run has no human available to confirm.
> Any tier that requires confirmation must degrade to a no-write artifact
> (patch file or instruction block) instead of waiting on input that will
> never arrive.

> **Dead-End Prevention Principle:** Every prohibited or hard-stopped action must be
> accompanied by clear, actionable user-facing instructions. Never leave the user
> without a next step.

### Tool Availability Check

Run the following detection block first:

```bash
# Detect OS and package manager
OS="unknown"
PKG_MANAGER="unknown"
uname -s | grep -qi "darwin"  && OS="macos"
uname -s | grep -qi "linux"   && OS="linux"
uname -s | grep -qi "mingw\|cygwin\|msys" && OS="windows"

command -v brew    &>/dev/null && PKG_MANAGER="brew"
command -v apt-get &>/dev/null && PKG_MANAGER="apt"
command -v dnf     &>/dev/null && PKG_MANAGER="dnf"
command -v yum     &>/dev/null && PKG_MANAGER="yum"
command -v pacman  &>/dev/null && PKG_MANAGER="pacman"
command -v winget  &>/dev/null && PKG_MANAGER="winget"
command -v choco   &>/dev/null && PKG_MANAGER="choco"

echo "OS=$OS | PKG_MANAGER=$PKG_MANAGER"

# Check each tool
git  --version 2>/dev/null && echo "git=ok"  || echo "git=missing"
tree --version 2>/dev/null && echo "tree=ok" || echo "tree=missing"
gh   --version 2>/dev/null && echo "gh=ok"   || echo "gh=missing"
jq   --version 2>/dev/null && echo "jq=ok"   || echo "jq=missing"
```

---

### Tool Classification & Response Strategy

| Tool | Required? | If Missing |
|---|---|---|
| `git` | ⚙️ **Conditional** | Required when deliverables include git workflow content (`GIT_WORKFLOW.md`, branch strategy, CODEOWNERS, commit-hash changelog) or Mode B migration of a git repo: read `references/environment-setup.md` and run its decision tree (confirm-first install → manual guide → sandbox hard stop). Optional for documentation-type projects (A1 = D or E) or when the user declines git: skip git-dependent deliverables and note the omission in the plan document - never hard-stop a deliverable that does not need git. |
| `tree` | Optional | Silent fallback to `find` - no user action needed |
| `gh` | Optional | Skip branch protection checks; note omission in plan document |
| `jq` | Optional | Use plain text parsing; no user action needed |

Optional-tool fallback details: see the table at the end of
`references/environment-setup.md`.

---

## Phase 1 - Mode Detection

Determine which operating mode applies:

```
┌─────────────────────────────────────────────────────────┐
│  Does the project already have an existing workspace     │
│  structure the user wants to work with?                  │
├─────────────────────────────────────────────────────────┤
│  NO  → Mode A: Bootstrap (build from scratch)           │
│  YES → Mode B: Refactor (analyze and restructure)       │
│  Only the home-folder files → Mode C: Home only         │
└─────────────────────────────────────────────────────────┘
```

If unclear from the user's message, ask exactly one question:

> "您是想从零构建工作目录结构，改造现有的项目工作流，还是只设置主目录里的用户级指令文件？ /
>  Are you building a new workspace from scratch, refactoring an existing one,
>  or only setting up your user-level instruction files?"

**Mode C** writes only the user-level instruction files (personal defaults in
the home folder) and builds no workspace. Read `references/user-level-files.md`
now and follow its Mode C route, which replaces Phases 2-6 below.

---

## Phase 2 - Existing Structure Capture (Mode B Only)

Skip this phase entirely for Mode A.

Capture the existing workspace structure using the highest-priority available method:

### Method 1 - Active Scan (Preferred, run if environment permits)

```bash
# Attempt tree first; fall back to find if unavailable
if command -v tree >/dev/null 2>&1; then
  tree -L 4 -a --noreport -I '.git|node_modules|__pycache__|.DS_Store|*.pyc'
else
  find . -not -path '*/.git/*' \
         -not -path '*/node_modules/*' \
         -not -path '*/__pycache__/*' \
         -not -name '.DS_Store' \
  | sort | sed -e 's|[^/]*/|  |g'
fi
```

### Method 2 - User Upload

If active scan is not possible (no filesystem access), ask:

> "请上传您的目录结构文件，支持以下格式：`tree` 命令输出的文本、截图、或导出的结构文件。 /
>  Please upload your directory structure - accepted formats: `tree` command output text,
>  a screenshot, or any exported structure file."

### Method 3 - User Description (Fallback)

If neither scan nor upload is possible:

> "请用文字描述您现有的工作目录结构，包括主要目录名称和它们的用途。 /
>  Please describe your existing workspace structure in text - include main directory
>  names and their purposes."

Once structure is captured, proceed to Phase 3.

---

## Phase 3 - Requirements Elicitation (Dual-Track)

This is the core information-gathering gate. The full bilingual question bank
(A1-A6, B0-B10) lives in `references/elicitation-questions.md` - read it on
entering this phase. The add-on questions U1-U3 (user-level instruction files
in the home folder) live in `references/user-level-files.md`; ask U1 right
after B0, whatever B0 chose.

### Gate Rules

- Ask only **ONE** question per turn. Questions must include concrete options
  (A/B/C/D). Challenge flawed or contradictory inputs before accepting them.
- **Completion gate (testable):** Phase 4 may begin only when every question in
  the active set has exactly one of: (a) a user answer, (b) a preset default,
  or (c) a pruning-matrix resolution. The active set is the full bank minus
  preset-covered and pruned questions. Do not display confidence percentages -
  completion is binary and auditable.
- **Escape hatch:** the user may say "立即生成 / generate now" at any time.
  Fill every unanswered question with the active preset's defaults (Solo-Lite
  if no preset was chosen), and mark every defaulted item with `*` in the
  confirmation summary.

### P0. Preset Profile Selection (always the first question)

> **选择一个起点画像，或逐项定制？ / Pick a starting profile, or customize item by item?**
>
> 画像会为大部分问题填入合理默认值，只保留少数必答项。所有默认值都会在
> 确认摘要中列出，进入 Phase 4 前可以逐项覆盖。
> *(A profile pre-fills sensible defaults for most questions, leaving only a few
> that must be asked. Every default is listed in the confirmation summary and
> can be overridden before Phase 4.)*
>
> A) **Solo-Lite** - 个人项目，最小流程。剩余必答：A1（项目类型/技术栈）、B0（Agent 选择）、B1（仅当选择 Claude）。
>    *(Solo project, minimal process. Remaining questions: A1, B0, B1 if Claude.)*
> B) **Team-Standard** - 2-20 人团队，结构化协作。剩余必答：A1、B0、B1（如适用）、B4（如多 Agent）、B5、B10 追问（已有保证机制）。
>    *(Team of 2-20, structured collaboration. Remaining: A1, B0, B1 if applicable, B4 if multi-agent, B5, B10 follow-up (existing guarantees).)*
> C) **Enterprise-Full** - 20+ 人，完整治理。剩余必答：同 B，外加 A3 平台确认。
>    *(20+ people, full governance. Remaining: same as B, plus A3 platform confirmation.)*
> D) **逐项定制 / Custom** - 走完整问卷（剪枝矩阵仍然生效）。
>    *(Full question bank - the pruning matrix still applies.)*

**Preset default table** (every cell can be overridden at the summary):

| Question | Solo-Lite | Team-Standard | Enterprise-Full |
|---|---|---|---|
| A2 Team scale | A (solo) | B/C (per stated size) | D (20+) |
| A3 CI/CD | A (none) | B (GitHub Actions) | ask (platform confirmation) |
| A4 Branch strategy | A (GitHub Flow) | A (GitHub Flow) | B (Git Flow) |
| A5 Changelog | A (none) | B (manual) | C (agent-maintained) |
| A6 Agent file tracking | A (exclude) | C (track `GIT_WORKFLOW.md` only) | C (track `GIT_WORKFLOW.md` only) |
| B2 Memory strategy | C (hybrid) | C (hybrid) | B (persistent) |
| B3 Memory categories | A (basic 4: three memories + operational rules) | B (A + shared) | C (A + shared + private) |
| B4 Division of work (multi-agent only) | A (one lead writes); lead follow-up still asked | ask | ask |
| B5 Agent-Git ownership | B (one agent drafts) | ask | ask |
| B6 GIT_WORKFLOW scope | A (basic) | B (merge + PR standards) | D (full governance) |
| B7 Failure strategy | B (pause + ask) | B (pause + ask) | C (human-directed fallback) |
| B8 Audit | B (lightweight) | C (structured) | D (full audit trail) |
| B9 Memory cleanup | A (event-driven standard) | C (event-driven + iteration review) | C (event-driven + iteration review) |
| B10 Rule enforcement | A (all prose-level) | B (mark absolutes); follow-up still asked | C (B + wiring checklist); follow-up still asked |
| U1 User-level instruction files | A (none) | A (none) | A (none) |

### Conditional Pruning Matrix

Apply on top of any preset, and in Custom mode. A pruned question is resolved,
not skipped silently - its resolution appears in the confirmation summary.

| Condition | Pruned | Resolution |
|---|---|---|
| A1 = A | PHASE 2 branch | generate Branch S (Engineering); [A1 = A ONLY] blocks included |
| A1 = B/C | PHASE 2 branch | generate Branch E (Data & Experiment); skip [A1 = A ONLY] blocks |
| A1 = D | PHASE 2 branch; tech-stack sub-question | generate Branch D (Document & Research); skip tech-stack question |
| A1 = E | PHASE 2 branch; tech-stack sub-question | generate Branch C (Content Operations); skip tech-stack question |
| A1 = F | PHASE 2 branch; tech-stack sub-question | generate Branch P (Prompt & Agent Engineering); skip tech-stack question |
| A1 = G | PHASE 2 branch | generate Branch O (Ops & Infrastructure); tech-stack question still asked (IaC tools matter) |
| No mixed deliverables detected in A1 | A1-combo question | primary branch only; no combination |
| A1 = D or E, and user declines git | A3, A4, A5, A6, B5, B6 | omit all git-dependent deliverables; note in plan; B8 capped at C |
| A2 = A (solo) | CODEOWNERS / branch protection content | B6 capped at option B |
| B0 = single agent | B4 | no Multi-Agent Coordination subsection |
| B0 excludes Claude | B1 | no Claude-specific config |
| U1 = A | U2, U3 | no user-level instruction file |
| U3 = A | U3 follow-up | no Decision Support section in the personal-defaults block |
| B2 = D (no memory) | B3, B9 | `MEMORY.md` not generated; B8 = B has no Decision Memory to log to -- ask: A or C |
| B5 = A (no agent Git) | agent rows in Git responsibility tables | "Human only" everywhere |

### Confirmation Summary

Once the completion gate is met, display (mark preset defaults with `*`):

```
╔════════════════════════════════════════════════════════════╗
║         REQUIREMENTS CONFIRMED - READY TO PLAN            ║
╠════════════════════════════════════════════════════════════╣
║ Preset:        Solo-Lite / Team-Standard / Enterprise /    ║
║                Custom                                      ║
║ Mode:          Bootstrap / Refactor                        ║
║ Project Type:  <detected type>                             ║
║ Tech Stack:    <stack>                                     ║
║ Team Scale:    <scale>                                     ║
║ CI/CD:         <selection>                                 ║
║ Git Strategy:  <strategy>                                  ║
║ Changelog:     <A5 selection>                              ║
║ File Tracking: <A6 selection>                              ║
║ Secondary QA:  <none / Branch X checklist borrowed>        ║
║ Agents:        <selected agents>                           ║
║ Files to gen:  <list of agent files>                       ║
║ User-level:    <none / user-level instruction file paths>  ║
║ 2nd Opinion:   <U3: none / Round 1 / Rounds 1-2 / custom>  ║
║ Memory:        <strategy + categories>                     ║
║ Git-Agent:     <ownership map>                             ║
║ Failure:       <fallback strategy>                         ║
║ Audit:         <logging level>                             ║
║ Enforcement:   <B10 level + named mechanisms>              ║
╠════════════════════════════════════════════════════════════╣
║  Gate: all items answered / *defaulted / pruned ✅         ║
║  Override any *defaulted line now, or confirm to proceed   ║
║  to Plan Document generation.                              ║
╚════════════════════════════════════════════════════════════╝
```

---

## Phase 4 - Plan Document Generation

Generate the full plan document before any file is written to disk.
Present this to the user for review and confirmation.

The plan document contains two categories of deliverables (three when U1 != A):

- **Category A - Project Workflow Files (Human-Oriented):** directory structure,
  key file templates, workflow standards, migration path (Mode B). Read
  `references/project-file-templates.md` for the full templates and rules.
- **Category B - AI Agent Workflow Files (Agent-Oriented):** `CLAUDE.md`,
  `AGENTS.md`, `GEMINI.md`, `MEMORY.md`, `GIT_WORKFLOW.md` per the B0 generation
  matrix. Read `references/agent-file-templates.md` for the assembly rules,
  shared blocks, and core templates; `references/phase-2-branch-templates.md`
  for the branch-specific Phase 2 template (select one by A1);
  `references/git-workflow-template.md` for the GIT_WORKFLOW.md template.
  Generated files must be fully self-contained (Method Y) - the source
  templates are stored DRY, but every generated file receives complete copies
  of all shared blocks.
- **Category C - User-level Instruction Files (only when U1 != A):** the
  managed personal-defaults block for each U1 target in the home folder. These
  load in every project on the machine, so they carry personal defaults only,
  never this project's rules; Category B stays complete without them. Read
  `references/user-level-files.md` for the block template, target resolution,
  and the 🟠 Home tier write procedure.

### Plan Document Confirmation Gate

After generating the full plan document, display:

```
╔═════════════════════════════════════════════════════════════╗
║              PLAN DOCUMENT - PENDING CONFIRMATION           ║
╠═════════════════════════════════════════════════════════════╣
║ Category A Files:                                           ║
║   📁 Directory structure (<N> directories)                  ║
║   📄 <N> key file templates                                 ║
║   📋 Workflow standards document                            ║
║   [🔄 Migration path - Mode B only]                        ║
╠═════════════════════════════════════════════════════════════╣
║ Category B Files:                                           ║
║   PHASE 2 branch: <S / E / P / D / C / O>                    ║
║     (selected by A1)                                         ║
║   Secondary QA:  <none / + Branch X checklist>              ║
║   🤖 CLAUDE.md    ✅ Ready                                  ║
║   🤖 AGENTS.md    ✅ Ready                                  ║
║   🤖 GEMINI.md    ✅ Ready                                  ║
║   🧠 MEMORY.md    ✅ Ready                                  ║
║   🌿 GIT_WORKFLOW.md  ✅ Ready                              ║
╠═════════════════════════════════════════════════════════════╣
║ Category C Files (home folder - only when U1 != A):         ║
║   👤 <each U1 target path>  ➕ personal-defaults block      ║
╠═════════════════════════════════════════════════════════════╣
║  ✅ 输入 "confirm" 开始执行落地                             ║
║     Type "confirm" to begin execution                       ║
║  ✏️  输入 "edit <section>" 修改某个部分                     ║
║     Type "edit <section>" to revise a section               ║
║  ❌ 输入 "cancel" 终止                                      ║
║     Type "cancel" to abort                                  ║
╚═════════════════════════════════════════════════════════════╝
```

Do not proceed to Phase 5 until the user explicitly confirms.

---

## Phase 5 - Execution (File Creation & Migration)

Execution runs in five risk-tiered steps: directory creation and new-file
creation (auto-execute), file modifications (diff + confirm), deletions and
overwrites (explicit confirmation), then the execution summary -- plus Step 3b,
the user-level instruction files (🟠 Home tier), only when U1 != A. The full step
procedures, their shell commands, and the risk gates are in
`references/execution-steps.md` -- read it when entering Phase 5, and follow
the Tiered Permission Control rules from Phase 0 throughout.

Nothing in Phase 5 begins until the Phase 4 plan document is confirmed.

**Every validation declares its rung** on the check ladder -- **A-check** (a
command returns pass/fail; may claim PASS alone), **O-check** (run it, then
assert a required literal appears; PASS only with the literal quoted), or
**J-check** (judgment; never a bare PASS). Write each check before the content
it validates and confirm it fails first. The ladder, the validation tables and
the BLOCKED rule are in `references/execution-steps.md`.

---

## Phase 6 - Sync Consistency Enforcement

Applies whenever the user requests a change to **any** agent workflow file
after initial generation. Since all agent files are fully self-contained
(Method Y), changes to shared content (Core Operating Rules, Project
Mandates, memory policies, Git responsibilities) must propagate to every
affected file.

> **Post-initialization rule ownership:** the instruction files (`CLAUDE.md` /
> `AGENTS.md` / `GEMINI.md`, `GIT_WORKFLOW.md`) are read-only to the working
> agent after initial generation. Day-to-day durable-rule changes land only
> in `MEMORY.md` (Operational Specification Rules); instruction files change
> only through this skill or on explicit user instruction.

### Sync Trigger Detection

Detect if a requested change affects shared content:

| Change Type | Affected Files | Action |
|---|---|---|
| Core Operating Rules update | All agent files | Sync all |
| Project Mandates update | All agent files | Sync all |
| Memory policy change | All agent files + `MEMORY.md` | Sync all |
| Git responsibility change | All agent files + `GIT_WORKFLOW.md` | Sync all |
| Agent-specific change only | Only that agent's file | Update single file |
| Operational rule change (post-init, by the working agent) | `MEMORY.md` only | No sync - rules live in `MEMORY.md` |
| Personal defaults change | U1 user-level instruction files, managed block only | Run Mode C (🟠 Home tier); a workspace sync never touches these files |

### Sync Execution

Before syncing, display:

```
🔄 SYNC REQUIRED - Shared content changed

This change affects shared sections in:
  🤖 CLAUDE.md
  🤖 AGENTS.md
  🤖 GEMINI.md

Proposed changes will be applied identically to all files above.
Each file will show a diff for confirmation before writing.

Proceed with sync? [yes/no]
```

Apply Phase 5 risk tiers to all sync operations.

---

## Edge Cases & Error Handling

| Situation | Action |
|---|---|
| Working directory is not a git repo | Warn; ask if user wants to initialize with `git init` |
| `tree` and `find` both unavailable | Ask user to paste directory listing manually |
| User uploads unreadable screenshot | Ask for text-format `tree` output instead |
| Conflicting answers between Track A and Track B | Surface the conflict explicitly; ask one resolution question |
| User requests agent file for unsupported agent | Generate a generic `<AGENT_NAME>.md` using the standard template structure |
| Plan document is partially rejected | Re-enter Phase 4 for rejected sections only; do not regenerate approved sections |
| Execution interrupted mid-way | Log completed steps; resume from interruption point on next run |
| File write fails (permissions) | Display exact error; provide `chmod` or `sudo` guidance |
| Sync conflict: user edited a file manually between generations | Show diff of manual edit vs. proposed sync; ask user which version to keep |
| Software project detected but Living Documentation mandate not added | Automatically include it; notify user |
| Confirmation required but environment is non-interactive (CI/sandbox) | Never wait for input; degrade per the Non-interactive rule: emit patch/instruction artifacts and continue |
| A1 = H (Other) | Ask one branch-selection question: build-like -> S, data/experiment-like -> E, research/report-like -> D, recurring publishing -> C, prompt/agent work -> P, infra/deploy/SRE -> O; if still ambiguous, default to D for writing-like work and say so |
| A1-combo: secondary same as primary | Do not offer combination; a branch cannot borrow from itself |
| A1-combo: user wants two secondary branches | Cap at 1; explain the constraint and ask the user to pick one |
| Documentation or content project (A1 = D or E), user declines git, git is missing | Proceed without git; omit git-dependent deliverables; note omission in plan document - do not hard-stop |
| U1 != A: Codex override file, `CLAUDE_CONFIG_DIR` or `GEMINI_CLI_HOME` set, Gemini `context.fileName`, broken markers, one file reached twice, an Other target that is no plain file, sandbox | Follow the Edge Cases table in `references/user-level-files.md` |
| Single-file edition: a pointer says "read references/..." | The same content is in the appendices of this document - read the matching appendix section instead |

---

## Quick Reference - Key Commands

Directory visualization, git init, branch-protection and CODEOWNERS checks, and
the agent-workflow-file tracking commands are collected at the end of
`references/execution-steps.md`.
