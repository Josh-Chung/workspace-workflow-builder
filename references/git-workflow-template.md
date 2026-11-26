---
id: git-workflow-template
scope: "GIT_WORKFLOW.md template: dual-track Solo+Team git standards, branching, commits, CI, agent decision policy"
read-when: "Phase 4 plan document generation -- Category B git workflow generation"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, git-workflow, generation, category-b]
---

#### `.workflow-references/GIT_WORKFLOW.md` - Git Standards & Agent Git Responsibilities

> **Structure note:** this template is generated at `.workflow-references/GIT_WORKFLOW.md`
> within the project. It mirrors the dual-track (Solo + Team) structure.
> Part A (Shared Core) is always included. Parts B-E are conditionally
> included based on elicitation variables A2, A3, A4, A5, B5, B6. Adapt
> `.gitignore` rules and CI config to the tech stack from A1.

````markdown
# Git Workflow & Best Practices (Solo + Team)

**Dual-track:** Solo (speed + safety) and Team (+ branch protection, review,
CI). Solo projects follow the Shared Core so they can graduate to Team mode
without rework.

**Reading guide:** check entry file's Git mode. Read Part A (Shared Core) +
your mode's part (B=Solo, C=Team). Skip the other. Part D = adoption priority.
Part E = Agent Decision Policy (skip if mode already declared).

---

## Part A - Shared Core (Both Modes)

**Git boundary (governs every rule in this file, both modes):** push, merge,
and branch deletion are user-approved actions. The agent proposes the action
and names the exact command; the user runs or approves it. Where a rule below
reads "push", "merge", or "delete the branch", read it as "propose it, then act
on approval" -- never as licence to act unprompted. Local-only work (branch,
stage, commit) needs no approval and should stay frequent.

**Exception -- updating from the remote (A.9):** `git fetch`, and a
fast-forward of a clean branch to commits the remote already has, need no
approval: they lose nothing and create nothing. Report what came in. A rebase
or a real merge is not a fast-forward and keeps the approval step.

### A.0 Default Branch Name Convention

Throughout this document, `main` refers to the repository's **actual default
branch**, whatever it is named (`main`, `master`, `trunk`, `develop`, ...).
Detect it once per session, in this order:

1. `git symbolic-ref --short refs/remotes/origin/HEAD` (strip the `origin/`
   prefix from the output).
2. If that fails and `gh auth status` succeeds:
   `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
3. If both fail: if exactly one of `main` / `master` / `trunk` exists locally,
   use it.
4. If still ambiguous: ask the user once and cache the answer for the session.

Never assume the default branch is literally named `main`, and never create a
new branch named `main` just because these rules mention it.

### A.1 Repository Initialization

Every new repo starts with at least these files:

```
+-- README.md          # Project overview and quick-start
+-- .gitignore         # Ignore rules (generate via gitignore.io)
+-- LICENSE            # Open-source license if applicable
```

[A2 >= B ONLY]:

For Team mode, add:

```
+-- CONTRIBUTING.md                       # How collaborators participate
+-- .github/
    +-- PULL_REQUEST_TEMPLATE.md          # PR template
    +-- ISSUE_TEMPLATE/                   # Issue templates
```

**`.gitignore` rules:**
- <Derived from A1: tech-stack-specific ignore patterns (Python, Node, Go, etc.)>
- **Agent temp files:** ignore the temp directory used for scratch work
  (default `.tmp/`) so nothing a clear pass (A.8) would delete can ever be
  committed.
- **Security (universal):** never commit secret files such as `.env`, API keys,
  signed certs, or local credential dumps.
- Create the `.gitignore` **before the first commit** so secrets cannot leak
  into history.

### A.2 Commit Often, Commit Small

- Save changes (make a commit) frequently.
- Only include related changes in a single commit. **One commit = one logical
  change** - that is what makes review and revert easy.
- **Rule of thumb:** every time a small task (a new function, a bug fix, a doc
  update) is finished, make a commit.
- **Before each commit:** run the temp-file clear pass (Section A.8) so
  scratch files never enter history.

### A.3 Commit Message Format - Conventional Commits

Use the **Conventional Commits** convention everywhere.

[A5 = C ONLY]: It is the same format the project's root-level `CHANGELOG.md`
rule (in the root agent workflow file: `CLAUDE.md` / `AGENTS.md` /
`GEMINI.md`) requires, so following it here keeps git history and the changelog
aligned by construction.

**Format:**

```
<type>(<scope>): <short description in imperative mood, <=72 chars>

[optional body: explain what and why, not how]

[optional footer: related issue, breaking change]
```

**Allowed types:**

| Type | Use for |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Refactor that is not a feat or a fix |
| `docs` | Documentation only |
| `test` | Add or change tests |
| `chore` | Build, deps, tooling, housekeeping |

**Golden rules:**
- Imperative mood: "add", not "added" or "adds".
- Describe **what** and **why**, not how. The diff already shows how.
- Subject line <=72 characters. Wrap the body at ~100.

[A5 = C ONLY]: any commit paired with a `CHANGELOG.md` entry must include
`scope` - the changelog entry header format requires it.

### A.4 Branch Naming Convention

| Purpose | Format | Example |
|---------|--------|---------|
| New feature | `feature/<short-description>` | `feature/user-login` |
| Bug fix | `fix/<short-description>` | `fix/login-redirect` |
| Documentation | `docs/<short-description>` | `docs/api-guide` |
| Refactor | `refactor/<short-description>` | `refactor/auth-module` |
| Urgent prod fix | `hotfix/<short-description>` | `hotfix/payment-crash` |

[A4 = B ONLY]:
| Release | `release/<version>` | `release/v2.1.0` |

Branch names use kebab-case, stay short, and never include personal
identifiers (no `josh/...`).

### A.5 Branches Have Short Lives

- A branch exists to deliver **one** logical change. Once merged, propose
  deleting it; delete on approval.
- Long-lived feature branches accumulate conflicts. If a branch is older than a
  week, either ship it or rebase it onto the current `main`.
- The `main` branch is always the source of truth for "what works."

### A.6 Push to a Remote (Backup)

- Push your local repo to a remote (GitHub/GitLab) - at minimum once at the end
  of every working session.
- A commit that only exists on your laptop is not backed up. Push is the
  cheapest insurance available.
- **The agent proposes the push; the user runs or approves it** (Git boundary).
- Update from the remote before proposing any push (A.9).

### A.7 Bug-Fixing Workflow (Mandatory)

This section is referenced by name from `CLAUDE.md`. Follow it for every bug
fix in every mode.

#### A.7.1 Branch From the Branch That Contains the Bug

- Never fix a bug directly on the active branch, and never jump to `main` by
  default just because the task is a bug fix.
- First, identify the branch that actually contains the bug:
  - `git branch --show-current`
  - If unclear, inspect the branch graph before editing:
    `git log --decorate --graph --oneline --all -n 30`
- If the bug is on your current working branch, create the fix branch **from
  that branch**: `git checkout -b fix/name-of-the-bug`.
- Only start the fix branch from `main` when the bug truly belongs to `main` or
  you explicitly intend to patch `main`.
- After the fix is complete, merge the fix branch back into the branch it came
  from. **Do not** automatically merge every fix to `main`.

#### A.7.2 Merge Back and Clean Up Branches

- After merging the fix branch into its parent, propose deleting the merged fix
  branch immediately: `git branch -d fix/name-of-the-bug`; delete on approval.
- Review merged local branches: `git branch --merged <parent-branch>`.
- Delete any fully merged intermediate local branches between `main` and the
  updated parent **if they have no unique unmerged commits left** and are no
  longer the active working branch.
- **Never delete:**
  - `main`
  - the branch you are currently on
  - any branch with unmerged commits -- unless the user asks for that branch by
    name, in which case report what is on it, delete with `-D`, and give the
    tip SHA so the reflog can still recover it

Goal: keep the branch chain readable, avoid dead merged branches, and always
make it obvious which branch currently owns the ongoing work.

#### A.7.3 Useful Bug-Hunting Tools

| Tool | When | Quick usage |
|------|------|-------------|
| `git stash` | Need to switch branches mid-work | `git stash` -> fix bug -> switch back -> `git stash pop` |
| `git bisect` | Regression somewhere in N commits | `git bisect start` -> mark `bad`/`good` -> binary search -> `git bisect reset` |
| `git blame` | Unknown reason for a code line | `git blame <file>` shows commit + date per line |

### A.8 Temp File Clearing (Commit Gate + Task End)

Scratch files never enter history and never outlive the task.

| Condition | Action |
|-----------|--------|
| Before every commit | Delete the temp files this run created (default location `.tmp/`), then read `git status --porcelain`: a staged temp path is unstaged (`git restore --staged <path>`) and deleted before the commit |
| Task finished (with or without a commit) | Run the same clear pass; report what was removed, or state that none were created |
| A stray file this run did not create | Never delete it -- list it and ask the user |
| Deliverables, source, docs, `MEMORY.md` | Never temp; the clear pass never touches them |

### A.9 Update From the Remote Before Building on a Branch

Another device, session, or contributor can push to the remote at any time.
Work built on a copy the remote has moved past starts from an old commit, and
the gap surfaces late -- as a rejected push or a merge conflict. Compare with
the remote at every moment new work gets its base.

**When:** the first git operation of a session; before cutting a branch from
`main`; before merging into `main` or opening a PR; before proposing a push.
The comparison runs on the branch about to be built on, merged into, or pushed
-- `<branch>` below. No remote configured: skip this section (A.6 covers it).

**Compare (read-only):**

```
git fetch --prune origin
git rev-list --left-right --count <branch>...origin/<branch>
```

The output is `<ahead> <behind>`: commits only here, then commits only on the
remote. "Clean" below means `git status --porcelain --untracked-files=no`
prints nothing.

| State | Action |
|-------|--------|
| `0 0` -- up to date | Proceed |
| `N 0` -- ahead only | Proceed; the N commits are unpushed (A.6) |
| `0 N` -- behind, clean | Fast-forward, no approval needed (Git boundary): `git merge --ff-only origin/<branch>` on `<branch>`, or `git fetch origin main:main` to move `main` while another branch is checked out (it refuses anything but a fast-forward). Report the incoming commits, then proceed |
| `0 N` -- behind, uncommitted changes | Stop. Report the incoming commits (`git log --oneline <branch>..origin/<branch>`) and the changed files; propose committing first, then the fast-forward. Never stash or discard changes on your own initiative |
| `N M` -- diverged | Stop and report both sides (`git log --oneline origin/<branch>..<branch>` and `git log --oneline <branch>..origin/<branch>`). Count the local commits no remote has: `git rev-list --count <branch> --not --remotes`. Equal to N: propose `git rebase --rebase-merges origin/<branch>`, which replays them on the newest remote commit. Fewer than N: some are already pushed to another branch, and a rebase would copy them -- propose `git merge origin/<branch>` instead. Act on approval |
| A local branch cut from an older `main` | After `main` is current: unpushed, propose `git rebase main`; already pushed, leave it -- the merge into `main` (B.2, or the PR in Team mode) brings it up to date |
| A rebase or merge stops on a conflict | Stop and list the conflicting files; never resolve one without showing it. `git rebase --abort` or `git merge --abort` returns to the state before |
| `git fetch` fails (offline, no access) | Say so: the remote state is unknown. Local work may continue; compare again before any merge or push |
| A push is rejected (`fetch first` or `non-fast-forward`) | The remote moved since the last comparison: run this section again. Never force-push |

**Never:** a plain `git pull` (on a diverged branch it can create an unplanned
merge commit -- use the comparison and the table above), or `git push --force`
to `main`.

**Per-device setup (the user, once per machine):** `git config --global pull.ff only`
-- a manual `git pull` then refuses instead of creating a merge commit.

---

## Part B - Solo Mode

### B.1 Standard Session Workflow

1. **Verify state:** `git status`
2. **Confirm current branch:** `git branch --show-current`
3. **Update from the remote:** compare with `origin`; fast-forward if behind
   (Section A.9).
4. **New work?** Create the branch from the branch you are already working on,
   unless you explicitly want to start a fresh line from `main`:
   `git checkout -b <branch-name>`.
5. **Make changes:** write code and test.
6. **Stage:** `git add <file1> <file2>` (or `git add .` if you have just
   reviewed `git status`).
7. **Commit:** `git commit -m "<type>(<scope>): <short description>"`
   (Conventional Commits - see Section A.3).
8. **Backup:** propose `git push origin <branch-name>`; the user approves.

### B.2 Merging in Solo Mode

- Direct merge into `main` is acceptable in Solo mode. There is nobody to
  review you, so the review pressure becomes: **run the code locally before
  merging.** Merging into `main` still triggers the single confirmation prompt
  defined in Part E (E.6). Update `main` from the remote first (A.9); that
  fast-forward needs no confirmation.
- Prefer `git merge --no-ff <branch>` so each merged branch leaves a visible
  bubble in history. This makes future archaeology easier than fast-forward
  merges.
- After merge, propose pushing `main` and deleting the merged branch (see
  Section A.7.2); both happen on user approval.

### B.3 What Solo Mode Deliberately Skips

- Branch protection on `main` (you would only be blocking yourself).
- Mandatory PR + reviewer (no second pair of eyes available).
- Required CI checks (encouraged but not gated).

**However:** if a Solo project graduates to Team mode (a second contributor
joins, or it becomes a public repo), Part C must be turned on **before** the
new contributor's first commit lands.

---

[A2 >= B OR B6 >= B ONLY]:

---

## Part C - Team Mode

Team mode adds review, branch protection, and CI on top of the Shared
Core. Its full template lives in `git-workflow-team.md` -- read that file
when the project is Team mode, or when a Solo project graduates by adding
a second contributor (see B.3). Generate Part C into the same
`.workflow-references/GIT_WORKFLOW.md` file, directly after Part B.
