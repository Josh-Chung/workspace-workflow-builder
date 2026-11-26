---
id: git-workflow-team
scope: "GIT_WORKFLOW.md template, Part C: Team mode -- branch strategy, protection, PR flow, review etiquette, CI baseline, issues, permissions, onboarding"
read-when: "Phase 4 git workflow generation, when the project is Team mode or a Solo project graduates to a second contributor"
depends-on: [git-workflow-template]
priority: P1
tags: [templates, git, team-mode, generation, category-b]
---

## Part C - Team Mode

Adds review, protection, and CI on top of the Shared Core.

### C.1 Branch Strategy: <derived from A4>

[A4 = A ONLY]:

**Model:** GitHub Flow - the default for small-to-medium teams.

```
main                    # Always deployable
+-- feature/user-login
+-- fix/header-bug
+-- docs/update-readme
```

**Core rules:**
- `main` is **protected**: no direct pushes.
- Every change reaches `main` through a **Pull Request**.
- Branches are short-lived and deleted on merge.

[A4 = B ONLY]:

**Model:** Git Flow

<Generate full Git Flow diagram with main, develop, feature/*, release/*,
hotfix/* and describe the flow for each branch type.>

[A4 = C ONLY]:

**Model:** Trunk-Based Development

<Generate trunk-based description: short-lived branches (1-2 days max), heavy
automated testing, feature flags for incomplete work.>

[B6 >= C ONLY]:

### C.2 Branch Protection on `main`

Configure in **Settings -> Branches -> Branch protection rule**: require PR,
require 1 approval, require status checks, require up-to-date, disallow
bypass. Enable **before** inviting second contributor.

[B6 >= B ONLY]:

### C.3 Pull Request Flow

#### Lifecycle

```
Create PR -> CI runs automatically -> Assign reviewer ->
Code review -> Address comments -> Approval -> Squash and Merge -> Delete branch
```

#### Core PR rules

- PRs stay **small and focused**. Aim for <=400 lines of diff. Larger PRs
  review poorly and merge dangerously.
- The PR title follows the same Conventional Commits format as commits
  (Section A.3).
- At least **1 approving review** before merge. Move to 2 once the team grows
  past 4 contributors.
- Default merge strategy: **Squash and Merge**. This keeps `main` history
  one-commit-per-PR - easy to read, easy to revert.
- Never merge your own PR without review unless the repo has an explicit
  "trivial-docs-self-merge" carve-out and the PR meets it.

#### PR template

Put this at `.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## Summary
<!-- What does this PR do? -->

## Type of change
- [ ] feat
- [ ] fix
- [ ] docs
- [ ] refactor
- [ ] test
- [ ] chore

## Testing
- [ ] Tested locally
- [ ] Added/updated unit tests

## Related issues
Closes #

## Screenshots (if UI change)
```

### C.4 Code Review Etiquette

**Reviewer checks:** correctness, edge cases, style, security (injection,
secret leakage, authz), test coverage, naming clarity.

**Comment markers:** `[blocking]` must fix before merge. `[nit]` suggestion.
`[+1]` praise.

**Author rules:** respond to every comment (accept / push back / discuss).
Never merge over unresolved comments.

[A3 = B ONLY]:

### C.5 CI Baseline (GitHub Actions)

A minimum CI workflow at `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main]   # per Section A.0: substitute the repo's actual
                        # default branch
  pull_request:
    branches: [main]   # per Section A.0: substitute the repo's actual
                        # default branch

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies
        run: <derived from A1 tech stack>

      - name: Lint
        run: <derived from A1 tech stack>

      - name: Test
        run: <derived from A1 tech stack>
```

Effect: every push and every PR runs lint + tests; failures block merge via the
branch-protection rule in Section C.2.

[A3 = C ONLY]:

### C.5 CI Baseline

<Adapt CI config skeleton to the platform specified in A3.>

[A2 >= C OR B6 >= D ONLY]:

### C.6 Issue Management

| Use | Label |
|-----|-------|
| Bug report | `bug` |
| Feature request | `enhancement` |
| Documentation work | `documentation` |
| Discussion | `discussion` |
| Newcomer-friendly | `good first issue` |

**Rules of thumb:**
- Each PR links to its issue with `Closes #<n>` so the merge auto-closes it.
- Use **GitHub Projects** for a lightweight Kanban
  (`Todo -> In Progress -> Done`).
- Triage and close stale issues regularly; an old issue tracker is worse than
  no tracker.

[A2 >= C OR B6 >= C ONLY]:

### C.7 Permission Tiers

| Role | GitHub permission | Description |
|------|-------------------|-------------|
| Owner | Admin | Manages settings and access |
| Core contributor | Write | Creates branches, opens PRs, reviews |
| External contributor | Fork + PR | No direct write access |

Grant the **least** permission that lets each person do their job. Promote when
needed, demote on offboarding.

[A2 >= B ONLY]:

### C.8 Onboarding Checklist for a New Contributor

```
[ ] 1. Clone (or fork) the repo
[ ] 2. Read README.md and CONTRIBUTING.md
[ ] 3. Configure local git user.name and user.email
[ ] 4. Install dependencies, confirm the project runs locally
[ ] 5. Create a feature branch from main
[ ] 6. Code -> commit using Conventional Commits (Section A.3)
[ ] 7. Open a PR, fill out the template, request a reviewer
[ ] 8. Address review comments until approved and merged
```

---

## Part D - Adoption Priority

If you cannot adopt everything at once, roll out in this order:

```
Stage 1 - Immediately (any project, any size)
+-- Protect main from direct pushes (Team mode) / always branch off (Solo)
+-- Conventional Commits everywhere
+-- Every change in its own branch, even in Solo mode

Stage 2 - Once Stage 1 is steady
+-- CI on every PR (lint + test)
+-- PR template + review etiquette
+-- Issues + Projects for task tracking

Stage 3 - As the team grows
+-- Upgrade GitHub Flow to Git Flow if release branches are needed
+-- Semantic-versioned automated releases
+-- Polish CONTRIBUTING.md and external-contributor flow
```

---

[B5 != A ONLY]:

## Part E - Agent Decision Policy

Agents use this to decide Solo vs. Team silently before any git action.

### E.1 Design Principles

1. **Ordered checks, first match wins.** No holistic weighing.
2. **Bias toward Team.** Wrong-Team costs slowness; wrong-Solo can break `main`.
3. **Silent for Tier 0-2; ask only at Tier 3.**

### E.2 Tier 0 - Hard Overrides (any match -> Team)

**Precondition:** run `gh auth status` once. If it fails, skip all `gh` probes
in E.2-E.3, rely on filesystem + `git` only. A failed probe is never a Solo signal.

| Signal | Detection |
|--------|-----------|
| Public repo | `gh repo view --json visibility` |
| Org-owned repo | Remote URL owner != authenticated username |
| Branch protection on `main` | `gh api .../protection` non-404 |
| CI workflows exist | `.github/workflows/` inspection |
| `CODEOWNERS` or `SECURITY.md` exists | Filesystem |
| Production/users/regulated domain mentioned | Keyword match |

### E.3 Tier 1 - Strong Observable Signals (first match wins)

Run in order:

1. `git log --since="6.months" --format='%ae' | sort -u` returns **>= 2**
   unique emails -> **Team**
2. `CONTRIBUTING.md` or `.github/PULL_REQUEST_TEMPLATE.md` exists -> **Team**
3. Remote URL is the user's personal account **AND** repo is private **AND**
   only one committer in the last 6 months **AND** no PR history
   (`gh pr list --state all --limit 1` empty) -> **Solo**
4. No remote configured (`git remote -v` empty) -> **Solo**

If none match, proceed to E.4.

### E.4 Tier 2 - Conversation Intent Signals (only if E.3 did not decide)

Tally a weighted score from the last few conversation turns:

**Team signals (+1 each; bolded entries +2):**
- "team", "we", "our team", "colleague", "reviewer", "contributor"
- "PR", "pull request", "code review", "approve", "merge request"
- **"production", "deploy", "release", "live", "ship"**
- **"customer", "user-facing", "users depend on"**

**Solo signals (+1 each; bolded entries +2):**
- "my project", "personal", "private repo", "side project"
- "experiment", "prototype", "demo", "learning", "playground", "toy"
- **"just for me", "only I use it", "self-use"**

If net score >= +2 in one direction -> adopt that mode. Otherwise proceed to
E.5.

### E.5 Tier 3 - Fallback (only step allowed to ask the user)

If E.2-E.4 are all inconclusive, the agent **must** ask the user once via a
single structured question. Template:

> I could not determine the collaboration mode automatically (observed signals:
> [list]).
> Which mode should I apply for this session?
> - **Solo** - single committer, direct merge to `main` allowed
> - **Team** - multi-contributor, `main` protected, all changes via PR

Cache the answer for the remainder of the session. Do not re-ask unless a
re-evaluation trigger in Section E.7 fires.

### E.6 Behavior Differences Once a Mode Is Decided

| Operation | Solo behavior | Team behavior |
|-----------|--------------|---------------|
| Bug fix | `git checkout -b fix/<name>` -> fix -> merge back to parent (per Section A.7) | Same branch creation, but the fix lands via **PR**, not direct merge |
| Merging into `main` | Allowed; default to `git merge --no-ff` to preserve branch bubbles | **Forbidden** as a direct push; open PR, wait for green CI, then Squash and Merge |
| Push cadence | Push at end of session is enough | Push on every meaningful commit; push continuously while a PR is open |
| Commit message strictness | Conventional Commits; `scope` optional for ad-hoc commits, but **required** whenever the commit pairs with a `CHANGELOG.md` entry (the changelog header format includes `scope`) | Conventional Commits with **required** `scope` and subject <=72 chars |
| Deleting a merged branch | Propose the delete after merge-back; delete on approval (still honoring the never-delete list in Section A.7.2) | **Confirm** before delete; only delete branches that were merged via PR |
| Operations touching `main` | Single confirmation prompt | **Hard confirmation** plus a reminder of the branch-protection rules in Section C.2 |
| Updating from the remote (Section A.9) | Fast-forward a clean branch without confirmation | Same: a fast-forward of local `main` to commits that already passed review needs no confirmation |

### E.7 Re-evaluation Triggers

Re-run the full decision flow whenever:

- A new committer email appears in `git log`.
- The repo's remote URL changes (added, removed, or switched).
- The user switches to a different project directory.
- The conversation introduces a production / deployment / user-facing concern
  for the first time.
- The user explicitly states "someone else is joining" or equivalent.

### E.8 Failure Handling

- Probe error -> degrade to E.4 + E.5 (never default to Solo).
- Solo user requests Team action (e.g. "open PR") -> switch temporarily.
- Team user requests direct push to `main` -> refuse, redirect to PR flow.

---

## Appendix - Quick Reference

**Conventional Commit types (allowed in this repo):** `feat`, `fix`,
`refactor`, `docs`, `test`, `chore`

**Commit message template:**
`<type>(<scope>): <imperative description <=72 chars>`

**Branch prefixes:** `feature/`, `fix/`, `docs/`, `refactor/`, `hotfix/`

**The four bug-hunt commands:** `git stash`, `git bisect`, `git blame`,
`git log --decorate --graph --oneline --all`

**Never delete:** `main` or the branch you are on; a branch with unmerged commits only when the user names it (report what is on it, then its tip SHA).

**Update from the remote (A.9):** `git fetch --prune origin`, then
`git rev-list --left-right --count <branch>...origin/<branch>` (ahead, behind).
````

---
