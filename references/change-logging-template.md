---
id: change-logging-template
scope: "Change Logging Rule block injected into every generated Agent file when A5 = C"
read-when: "Phase 4 generation, only when A5 = C (changelog with commit hashes)"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, generation, category-b, change-logging]
---

#### Change Logging Rule Block *(injected into all Agent files when A5 = C)*

````markdown
## Change Logging Rule (Mandatory on Every Meaningful Action)

After **every meaningful action** - code creation, modification, deletion, bug fix,
doc update, or config change - follow these steps in order:

**Step 1 - Write the changelog entry first.**
Prepend a new entry to the top of `## Changelog` in the project root `CHANGELOG.md`.
If the file does not exist, initialize it using the File Initialization Template
defined in `.workflow-references/GIT_WORKFLOW.md`. Use `PENDING` as the commit hash placeholder.

**Step 2 - Atomic commit.**
Stage all changed files together with `CHANGELOG.md` (`git add`), then perform
a single `git commit`. The changelog update and the code change must always be
in the same commit - never separate.

**Step 3 - Lazy back-fill of the commit hash.**
Leave `PENDING` in place after committing. It is back-filled the next time
`CHANGELOG.md` receives a substantive modification (normally the next entry):
inside that same atomic commit, replace every older `PENDING` with its real
40-character SHA. Find the SHA by matching the entry header to its commit
message - they are word-for-word identical by rule:
```bash
git log --format="%H %s"  # if several commits share a message, pick the one whose commit time matches the entry timestamp
```
At any moment, at most the most recent entry carries `PENDING`. Never create a
dedicated hash-backfill commit, and never use `git commit --amend` to inject
the hash - amending mutates the SHA it is trying to record.

**Step 4 - Enforce the retention ceiling (50 entries or 32,768 bytes).**
After prepending, count the `###` entry headers under `## Changelog` and measure
its byte size. While the count exceeds 50, or the file exceeds 32,768 bytes,
delete the oldest entry at the bottom. The count is always derived by counting
headers - never maintain a separate counter field.

**Commit message format:**
```
<type>(<scope>): <short description in imperative mood, <=72 chars>
```
The git commit message must be **word-for-word identical** to the
`<type>(<scope>): <short description>` portion of the changelog entry header.

**Allowed types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

**Rules:**
- **Log first, commit together.** Write the entry before committing; stage
  `CHANGELOG.md` alongside all other changed files in a single commit.
- **Prepend only.** New entries go at the top of `## Changelog` - never append.
- **No abbreviation.** List every individual file touched with its exact path,
  action (`created` / `modified` / `deleted` / `renamed`), and a brief inline
  description of what specifically changed. Do not group files or use "etc."
- **Full SHA only.** The back-filled hash must be the full 40-character SHA,
  never a short hash. `PENDING` is the only permitted placeholder, and only on
  entries not yet lazily back-filled (at most the most recent entry).
- **No self-logging.** Changes to `CHANGELOG.md` itself must never appear as
  a changelog entry - logging the log file would cause an infinite loop.
- **Cleanup rule.** The ceiling is 50 entries or 32,768 bytes, whichever comes
  first - entries counted from `###` headers under `## Changelog`. If prepending
  would breach either, delete oldest (bottom) entries until both hold.
- **Legacy spelling migration.** If a legacy `Changlog.md` (old spelling, missing
  the "e") exists, rename it first with `git mv Changlog.md CHANGELOG.md`, bundle
  the rename into the next commit, then treat the file as existing.
````
