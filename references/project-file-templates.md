---
id: project-file-templates
scope: "Category A templates: directory structure, key file templates, workflow standards, migration path"
read-when: "Phase 4 plan document generation (Category A deliverables)"
depends-on: []
priority: P0
tags: [templates, project-files, generation, category-a]
---

# Project File Templates (Phase 4 - Category A)

> Read this file when generating the Phase 4 plan document.
> Category A covers human-oriented project workflow files. Adapt every template
> to the elicited project type and tech stack - never emit a static copy.

## Contents

- A1. Directory Structure
- A2. Key File Templates (incl. git tracking policy and Changelog initialization)
- A3. Workflow Standards Document
- A4. Migration / Refactor Path (Mode B only)

---

### Category A - Project Workflow Files (Human-Oriented)

#### A1. Directory Structure

Present as an annotated tree:

```
<project-root>/
├── src/                    # Application source code
│   ├── components/         # Reusable UI components
│   ├── services/           # Business logic and API clients
│   └── utils/              # Shared utility functions
├── tests/                  # Test suites (mirrors src/ structure)
├── docs/                   # Project documentation
│   ├── architecture/       # Architecture decision records (ADRs)
│   └── api/                # API reference docs
├── .github/                # GitHub-specific configuration
│   ├── workflows/          # CI/CD GitHub Actions workflows
│   ├── CODEOWNERS          # Code ownership rules
│   └── PULL_REQUEST_TEMPLATE.md
├── .ai/                    # AI tool discoverability metadata
│   └── llms.txt            # Project description for AI tools (llmstxt.org)
├── CLAUDE.md               # Claude Agent workflow (router entry file)
├── AGENTS.md               # Multi-agent collaboration (router entry file)
├── GEMINI.md               # Gemini Agent workflow (router entry file)
├── MEMORY.md               # Agent memory classification and policy
├── .workflow-references/        # Companion files loaded on demand
│   ├── phase-1-discovery.md    # PHASE 1 procedure
│   ├── phase-2-execution.md    # PHASE 2 procedure
│   └── GIT_WORKFLOW.md         # Git workflow standards
└── README.md               # Project overview and onboarding guide
```

> Adapt structure dynamically to match detected project type and tech stack.
> Do not use a static template - generate based on elicited requirements.

#### A2. Key File Templates

For each file in the structure, generate a content template:

- `README.md`: Project overview, setup instructions, usage, contributing guide
- `.gitignore`: Tailored to tech stack (Node, Python, Go, etc.), with AI Agent workflow files excluded from git tracking by default (see rule below)
- `CODEOWNERS`: Map file paths to responsible teams/individuals
- `.github/PULL_REQUEST_TEMPLATE.md`: PR description template with checklist
- CI/CD config skeleton: Based on selected platform (GitHub Actions, GitLab CI, etc.)
- `CHANGELOG.md`: *(generated only if A5 = B or C)* Initialized with the File Initialization Template below; if A5 = C, the Change Logging Rule is also injected into all Agent workflow files.
- `docs/rule-enforcement-checklist.md`: *(generated only if B10 = C)* From the Rule Enforcement Checklist template below. A human to-do list, tracked in git like any doc.

- `.ai/llms.txt`: AI discoverability file per llmstxt.org standard. Contains
  project name, one-line description, key entry points, and links to docs.
  Generated during Phase 4; updated when project structure changes.

**AI Agent Workflow Files - Git Tracking Policy (Default: excluded)**

Default `.gitignore` excludes: `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`,
`MEMORY.md`, `.workflow-references/`, `CHANGELOG.md`, and `AUDIT_LOG.md` when
B8 = C. When B8 = D, `AUDIT_LOG.md` is never excluded, whatever A6 says: a
full audit trail depends on git history.

**Opt-in:** resolved by question **A6** in elicitation. Apply A6 selection;
do not re-ask.

**`CHANGELOG.md` Initialization Template** *(A5 = B or C, file absent)*:

```markdown
# <Project Name> - Project Changelog

Reverse-chronological. Format per Change Logging Rule in root agent file.
Max 50 entries or 32,768 bytes, whichever comes first (count `###` headers;
delete oldest until both hold).

---

## Changelog
```

**Full changelog entry format** *(prepended inside `## Changelog` on every meaningful change)*:

```markdown
### [YYYY-MM-DD HH:MM] <type>(<scope>): <short description>
**Commit:** `<full 40-char git commit hash - PENDING until lazily back-filled inside the next substantive CHANGELOG.md commit>`
**Affected paths:**
- path/to/file.py (created) - brief description of what was added
- path/to/other.py (modified) - brief description of what specifically changed
- path/to/old.py (deleted) - brief description of why it was removed
**Summary:** One or two sentences explaining the overall change and its purpose.
```

**Allowed types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

**`docs/rule-enforcement-checklist.md` Template** *(B10 = C)*: one row per
`prose-level request` row in the entry files' Rule Enforcement table.

```markdown
# <Project Name> - Rule Enforcement Checklist

Absolute rules in the instruction files that nothing guarantees yet. This
workflow generates no hooks or CI config: their names and syntax differ per
runtime and change between versions. Wire each row in your harness or CI,
then update its Enforced-by cell in every entry file.

| Rule | Suggested mechanism | Attach point | Wired |
|------|---------------------|--------------|-------|
| <rule, as in the Rule Enforcement table> | <permission rule / hook / CI step / review gate> | <where it would attach, e.g. before each commit, a CI job on pull requests> | no |
```

#### A3. Workflow Standards Document

Include inline within the plan:

- **Naming Conventions**: Files, directories, branches, PR titles
- **Branch Strategy**: Detailed flow based on selected Git strategy
- **Archiving Rules**: Where completed work, old docs, and deprecated code live
- **Team Collaboration Norms**: Review requirements, merge authority, release process

#### A4. Migration / Refactor Path (Mode B Only)

Present a structured diff:

```
╔══════════════════════════════════════════════════════════╗
║              REFACTOR PLAN - CHANGE SUMMARY              ║
╠══════════════════════════════════════════════════════════╣
║ ADDITIONS (🟢 Low Risk - auto-execute after confirm):    ║
║   + src/services/         (new directory)                ║
║   + CLAUDE.md             (new file)                     ║
║   + MEMORY.md             (new file)                     ║
╠══════════════════════════════════════════════════════════╣
║ MODIFICATIONS (🟡 Medium Risk - diff shown, confirm req):║
║   ~ README.md             (will be restructured)         ║
║   ~ .gitignore            (entries will be added)        ║
╠══════════════════════════════════════════════════════════╣
║ DELETIONS (🔴 High Risk - explicit confirm per item):    ║
║   - old_scripts/          (deprecated - confirm delete)  ║
║   - temp/                 (temporary files - confirm)    ║
╠══════════════════════════════════════════════════════════╣
║ MIGRATION STEPS:                                         ║
║   1. Create new directory structure                      ║
║   2. Move existing src files to new layout               ║
║   3. Generate AI Agent workflow files                    ║
║   4. Update README.md                                    ║
║   5. Remove deprecated directories (requires confirm)    ║
╠══════════════════════════════════════════════════════════╣
║ RISK WARNINGS:                                           ║
║   ⚠️  Moving files may break relative import paths       ║
║   ⚠️  Deletion of old_scripts/ is irreversible           ║
╚══════════════════════════════════════════════════════════╝
```

---

