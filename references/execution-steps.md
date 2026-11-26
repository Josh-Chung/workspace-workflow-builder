---
id: execution-steps
scope: "Phase 5 execution procedures: risk-tiered directory creation, new-file creation, modifications, user-level instruction files (Step 3b), deletions, execution summary, plus the key-command quick reference"
read-when: "Entering Phase 5 (after the Phase 4 plan document is confirmed)"
depends-on: [project-file-templates, agent-file-templates, user-level-files]
priority: P0
tags: [execution, file-creation, migration, risk-tiers, commands]
---

# Phase 5 Execution Steps

> Read on entering Phase 5, after the plan document is confirmed. Apply the
> Tiered Permission Control rules from `SKILL.md` Phase 0 to every step below:
> green auto-executes, yellow needs a diff plus confirmation, red needs
> explicit confirmation per item.

---

## Phase 5 - Execution (File Creation & Migration)

Execute only after user confirmation of the Phase 4 plan document.
Apply risk-tiered permission control from Phase 0 to every operation.

### Step 1 - Directory Creation (🟢 Low Risk - Auto-execute)

```bash
# Create all new directories
# Pre-check: confirm each directory does not already exist
for dir in "<dir1>" "<dir2>" "<dir3>"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo "[OK] Created: $dir"
  else
    echo "[SKIP] Already exists, skipping: $dir"
  fi
done
```

### Step 2 - New File Creation (🟢 Low Risk - Auto-execute)

Write each new file with its generated content. For files that did not previously
exist, write directly. Display a creation log listing **only the files actually
generated** per the B0 generation matrix and A5/A6 selections - never a
hardcoded list:

```
[OK] Created: <each generated agent file per B0 matrix>
[OK] Created: README.md
[OK] Created: .gitignore
[OK] Created: .github/PULL_REQUEST_TEMPLATE.md
([OK] Created: CHANGELOG.md - only if A5 = B or C)
```

**AI Agent workflow files - `.gitignore` injection (default: excluded):**

```bash
# Determine which agent files to exclude based on user's tracking selection
# Default (option A): exclude all agent workflow files
# Populate from the B0 generation matrix - list only files actually generated
AGENT_FILES="<generated agent files, e.g. CLAUDE.md AGENTS.md MEMORY.md GIT_WORKFLOW.md> CHANGELOG.md"

if [ "$AGENT_TRACKING" = "A" ] || [ -z "$AGENT_TRACKING" ]; then
  # Default: add all agent files to .gitignore
  echo "" >> .gitignore
  echo "# AI Agent workflow files (local only - not committed to repo)" >> .gitignore
  for f in $AGENT_FILES; do
    # Only add if not already present in .gitignore
    grep -qxF "$f" .gitignore || echo "$f" >> .gitignore
  done
  echo "[INFO] Added to .gitignore: $AGENT_FILES"

elif [ "$AGENT_TRACKING" = "B" ]; then
  # Track all: do not add to .gitignore
  echo "[OK] Agent workflow files will be tracked by git (no .gitignore entries added)"

elif [ "$AGENT_TRACKING" = "C" ]; then
  # Selective: add only user-specified files to .gitignore
  echo "" >> .gitignore
  echo "# AI Agent workflow files (selective - per user configuration)" >> .gitignore
  for f in $AGENT_FILES_TO_EXCLUDE; do
    grep -qxF "$f" .gitignore || echo "$f" >> .gitignore
  done
  echo "[INFO] Excluded from git: $AGENT_FILES_TO_EXCLUDE"
  echo "[OK] Tracked by git: $AGENT_FILES_TO_TRACK"
fi
```

**CHANGELOG.md creation logic (A5-conditional):**

```bash
# Only execute if user selected A5 = B or C
if [ "$A5_CHANGELOG" = "B" ] || [ "$A5_CHANGELOG" = "C" ]; then
  if [ ! -f "CHANGELOG.md" ]; then
    # Initialize using File Initialization Template
    cat > CHANGELOG.md << 'EOF'
# <Project Name> - Project Changelog

All changes are recorded here in reverse-chronological order (most recent first).
Format follows the Change Logging Rule in the project root agent workflow file (CLAUDE.md / AGENTS.md / GEMINI.md).

Max 50 entries or 32,768 bytes, whichever comes first. The entry count is
derived by counting `###` entry headers under `## Changelog` - there is no
manual counter to maintain. Before prepending a new entry, check both limits:
while the count is 50 or more, or the file is 32,768 bytes or larger, delete
the oldest entry at the bottom first.

---

## Changelog
EOF
    echo "[OK] Created: CHANGELOG.md"
  else
    echo "[SKIP] CHANGELOG.md already exists - skipping initialization."
  fi
fi

# If A5 = C, confirm Change Logging Rule has been injected into all Agent files
if [ "$A5_CHANGELOG" = "C" ]; then
  echo "[INFO] Change Logging Rule injected into: CLAUDE.md, AGENTS.md, GEMINI.md"
  echo "   Hash back-fill policy: PENDING back-filled inside the next substantive CHANGELOG.md commit (lazy; no dedicated hash commit; never git commit --amend)"
fi
```

**Check ladder (governs every validation below).** Each check declares which
rung it stands on, and the rung fixes what it may claim:

| Rung | What it is | May claim |
|------|-----------|-----------|
| **A-check** | a command reads the files and returns pass or fail -- the `grep` and table gates below | PASS or FAIL on its own |
| **O-check** | run the generated workflow, then assert a required literal appears in its output | PASS only with the literal quoted |
| **J-check** | judgment against a rubric, such as whether a rule reads unambiguously | never a bare PASS |

Write each check **before** the file content it validates and confirm it fails
first: a validation that has never failed describes what was generated rather
than what was required. A rung this runtime cannot reach is **BLOCKED (Requires
User Verification)**, never downgraded to a lower rung and passed.

**Post-write validation (instruction files) -- [A]:**

```bash
# ASCII invariant: generated instruction files must be pure ASCII.
# MEMORY.md is exempt - memory entries use the project's working language.
grep -P '[^\x00-\x7F]' CLAUDE.md AGENTS.md GEMINI.md GIT_WORKFLOW.md \
  && echo "[FAIL] non-ASCII found - regenerate the flagged file before continuing" \
  || echo "[OK] ASCII invariant holds"
```

**AI-readability validation (companion files) -- [A] except where noted:**

| Gate | Check | Fix on failure |
|------|-------|----------------|
| Frontmatter present | Every `.workflow-references/*.md` file has YAML frontmatter with `id`, `scope`, `read-when` | Prepend frontmatter block before the `# Title` line |
| Check ladder carried | The generated Phase 2 carries `CHECK_LADDER` as expanded text. `RED_FIRST` and `CHECK_EXECUTION` are carried **only** when the Loop-fit verdict is `loop`; under `ladder-only` they are absent and the plan document names which of the three tests failed. No `<!-- USE: -->` marker survives into a generated file either way | Expand the fragments from `agent-file-templates.md` per the verdict; if no verdict was recorded, go back and take it -- carrying the loop unweighed is the defect this row exists to catch |
| Condition-action format **[J]** | Rules use `condition -> action` or table rows, not prose paragraphs | Rewrite the rule as a table row or bullet with explicit trigger and action |
| Section self-containment **[J]** | Every section's first line summarizes its purpose without depending on prior sections | Add a one-line summary after each `##` heading |
| No synonym drift **[J]** | Same concept uses the same term throughout all generated files | Pick one term per concept; find-and-replace variants |

**Product AI-readability validation (entry files):**

| Gate | Check | Fix on failure |
|------|-------|----------------|
| Product provisions present | When the generated workflow produces downstream products (A1 = A, D, E, G), its Phase 2 Step 3 includes the `PRODUCT_AI_READABILITY` fragment content | Add the domain-appropriate product AI-readability provisions to Step 3 |
| Product QA present | The generated workflow's Phase 2 Step 5 includes a product AI-readability checklist item | Add the QA checklist item referencing Step 3 provisions |
| `.ai/llms.txt` generated | The project structure includes `.ai/llms.txt` | Create the file using the template from `project-file-templates.md` |

**Multi-agent validation (entry files) -- [A]:**

| Gate | Check | Fix on failure |
|------|-------|----------------|
| Multi-Agent Coordination present | When B0 selects more than one agent, every generated entry file carries the `Multi-Agent Coordination` subsection: the lead named from B4's follow-up, an ownership table in which no path appears in two agents' Writes cells (nested paths such as `src/` and `src/api/` count as overlap), the shared-log exception, and the five-field brief format. When B0 selects one agent, the subsection is absent | Generate the subsection from `entry-file-templates.md` per B4; ask the B4 follow-up if the lead or the owned paths are missing -- never invent them; give an overlapping path to one writer |
| Delegation carried | When Branch S or D is generated, its Phase 2 carries the `DELEGATION` fragment expanded, capability gate included | Expand `DELEGATION` from `agent-file-templates.md` |

**Audit and enforcement validation (entry files) -- [A]:**

| Gate | Check | Fix on failure |
|------|-------|----------------|
| Audit follows B8 | B8 = A: no `**Audit:**` line and no `### Audit Log`. B8 = B: the `**Audit:**` line only (absent when B2 = D). B8 = C: `### Audit Log` with its five-column header. B8 = D: seven columns, and `git check-ignore -q AUDIT_LOG.md` fails (the file is not ignored) | Regenerate the Audit line and section from `entry-file-templates.md` per B8; remove any pattern that ignores `AUDIT_LOG.md` |
| Enforcement follows B10 | B10 = A: no `## Rule Enforcement`. B10 = B, C or D: the section is present, and every Enforced-by cell is either `prose-level request` or a mechanism named in B10's follow-up -- none other. B10 = C: `docs/rule-enforcement-checklist.md` exists with one row per `prose-level request` row | Regenerate the section from `entry-file-templates.md`; a mechanism the user did not name becomes `prose-level request` |

### Step 3 - File Modifications (🟡 Medium Risk - Diff + Confirm)

For each file that already exists and requires modification, display a diff
before writing:

```
📄 Modifying: README.md
─────────────────────────────────────
- # Old Project Title
+ # <New Project Title>
+
+ ## AI Agent Workflow
+ This project uses Claude and Gemini. See CLAUDE.md and GEMINI.md.
─────────────────────────────────────
Confirm this change? [yes/no/skip]
```

Await per-file confirmation before writing.

**Non-interactive (sandbox/CI) degradation:** if no human can respond, do NOT
modify the file and do NOT wait. Write the proposed change as a patch file
(e.g. `<filename>.proposed.patch`), print the diff and the apply command
(`git apply <filename>.proposed.patch`), and continue with the remaining steps.

### Step 3b - User-level Instruction Files (🟠 Home Tier - only when U1 != A)

Runs after every workspace file is written; in Mode C (Home only) it is the
whole of Phase 5. Each U1 target lives in the home
folder and loads in every project on the machine, so this step never
auto-executes: show the full diff and confirm **per file, even for a new
file**. Follow the Write Procedure in `references/user-level-files.md`
exactly -- checks first, pre-image, compose by marker state, confirm, then
validate with its snippet. Only the managed personal-defaults block is ever
written; the user's own text outside the markers is never changed.

In a sandbox or CI run, write nothing to the home folder: emit
`user-level-personal-defaults.proposed.md` in the workspace with the
next-step instructions from that file, and continue.

### Step 4 - Deletions & Overwrites (🔴 High Risk)

**In Sandbox:** Hard stop. Provide user instructions:

```
🔴 HARD STOP - Deletion required but not permitted in sandbox environment.

The following items are marked for deletion:
  - old_scripts/   (deprecated directory)
  - temp/          (temporary files)

To complete this step, run the following in your local terminal:

  rm -rf ./old_scripts
  rm -rf ./temp

⚠️  These operations are irreversible. Verify backups before proceeding.
```

**In Non-Sandbox:** Prompt per item, require explicit confirmation:

```
🔴 DELETION REQUIRED - This action is irreversible.

Target: ./old_scripts/
Contents: 12 files, 3 subdirectories

Type "DELETE old_scripts" to confirm permanent deletion, or "skip" to abort:
```

Only proceed after receiving the exact confirmation string.

### Step 5 - Execution Summary

After all operations complete:

```
╔═════════════════════════════════════════════════════════════╗
║                  EXECUTION COMPLETE ✅                      ║
╠═════════════════════════════════════════════════════════════╣
║ ✅ Created:   <N> directories                               ║
║ ✅ Created:   <N> new files                                 ║
║ 🟡 Modified:  <N> existing files                            ║
║ 🔴 Deleted:   <N> items (confirmed by user)                 ║
║ ⏭️  Skipped:  <N> items (user chose to skip)               ║
╠═════════════════════════════════════════════════════════════╣
║ AI Agent Files Generated:                                   ║
║   🤖 CLAUDE.md       ✅                                     ║
║   🤖 AGENTS.md       ✅                                     ║
║   🤖 GEMINI.md       ✅                                     ║
║   🧠 MEMORY.md       ✅                                     ║
║   🌿 GIT_WORKFLOW.md ✅                                     ║
║   📋 CHANGELOG.md    ✅ / ⏭️ skipped (per A5 selection)    ║
╠═════════════════════════════════════════════════════════════╣
║ Git Tracking (Agent Files):                                 ║
║   🚫 Excluded (default) - added to .gitignore              ║
║   ✅ Tracked - committed to repo        (if option B)       ║
║   ⚙️  Selective - mixed per user config (if option C)       ║
╠═════════════════════════════════════════════════════════════╣
║ User-level Instruction Files (only when U1 != A):           ║
║   👤 <each U1 target>   ✅ block / 📄 .proposed (sandbox)   ║
║   ⏳ Live load checks: BLOCKED until you run them -         ║
║      Claude Code: /context all  |  Gemini CLI: /memory show ║
║      Codex, Antigravity, Other: see user-level-files.md     ║
╠═════════════════════════════════════════════════════════════╣
║ Next steps:                                                 ║
║   1. Review generated files and adjust agent-specific       ║
║      values (MCP tool names, team handles, etc.)            ║
║   2. Commit the project structure (agent files excluded     ║
║      by default): git add . && git commit                   ║
║   3. Share AGENTS.md with your team for onboarding          ║
║      (share the file directly - not via git, unless         ║
║      option B/C was selected)                               ║
║   [4. If A5=C: Agent will back-fill PENDING hash entries    ║
║       in CHANGELOG.md on the next edit to that file]        ║
╚═════════════════════════════════════════════════════════════╝
```

---

## Quick Reference - Key Commands

```bash
# Visualize current directory structure
tree -L 4 -a --noreport -I '.git|node_modules|__pycache__'

# Fallback directory listing
find . -not -path '*/.git/*' -not -path '*/node_modules/*' | sort

# Initialize git repo (if not already)
git init && git add . && git commit -m "chore: initialize workspace structure"

# Check branch protection (requires gh)
# "main" = the repo's actual default branch; detect first (GIT_WORKFLOW.md Default Branch Name Convention):
#   git symbolic-ref --short refs/remotes/origin/HEAD
gh api "repos/{owner}/{repo}/branches/main/protection"

# Validate CODEOWNERS syntax (requires gh)
gh api "repos/{owner}/{repo}/contents/.github/CODEOWNERS"

# Verify agent workflow files are correctly excluded (default behavior)
git check-ignore -v CLAUDE.md AGENTS.md GEMINI.md MEMORY.md GIT_WORKFLOW.md

# Opt-in: track agent workflow files if user selected option B
# git add CLAUDE.md AGENTS.md GEMINI.md MEMORY.md GIT_WORKFLOW.md
# git commit -m "chore: add AI agent workflow files"

# Opt-in: force-track a specific file even if in .gitignore (option C, per-file)
# git add -f GIT_WORKFLOW.md
# git commit -m "chore: add shared git workflow spec"
```

---
