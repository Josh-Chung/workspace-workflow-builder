---
id: phase-2-branch-templates
scope: "Index of the 6 conditional PHASE 2 branch templates; routes the A1 answer to the single branch file to read"
read-when: "Phase 4 plan document generation -- after reading agent-file-templates.md, select one branch by A1"
depends-on: [agent-file-templates]
priority: P1
tags: [templates, phase-2, branches, generation, category-b, index]
---

#### `.workflow-references/phase-2-execution.md` - PHASE 2 Procedure (Branch-Specific)

> **Structure note:** these templates generate a branch-specific PHASE 2
> procedure file at `.workflow-references/phase-2-execution.md`. Only one branch is
> generated per project, selected by A1. Fragment markers (`<!-- USE: X -->`)
> reference Shared Step Fragments defined in `agent-file-templates.md` and are
> expanded at generation time per the fragment expansion rule there. The full
> step content for each branch lives in its own file below; the entry file
> contains only a one-liner reference.

**Read exactly one branch file.** Each is self-contained -- its own frontmatter,
generation marker, and complete step content. Do not read the others.

| A1 answer | Branch | Read |
|-----------|--------|------|
| A - Software development | S (Engineering) | `phase-2-branch-s.md` |
| B / C - Data science, AI/ML engineering | E (Data & Experiment) | `phase-2-branch-e.md` |
| F - Prompt & agent engineering | P (Prompt & Agent Engineering) | `phase-2-branch-p.md` |
| D - Document & research writing | D (Document & Research) | `phase-2-branch-d.md` |
| E - Content operations | C (Content Operations) | `phase-2-branch-c.md` |
| G - Ops & infrastructure | O (Ops & Infrastructure) | `phase-2-branch-o.md` |

**Combination Mechanism:** when A1-combo selected a secondary branch, the
borrowed Step 5 QA checklist items are already written inline in each branch
file as `[COMBINATION: secondary=<branch>]` blocks -- include the matching
block. No second branch file is read, and no workflow step or routing rule is
ever borrowed.
