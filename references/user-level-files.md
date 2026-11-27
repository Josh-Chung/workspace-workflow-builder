---
id: user-level-files
scope: "Opt-in user-level instruction files in the home folder (Claude, Codex, Gemini, or a runtime the user names): the U1-U3 questions (U3: decision support), Mode C (Home only), verified load facts, the managed personal-defaults block, the Home-tier write procedure, the resolution and validation snippets, and edge cases"
read-when: "Phase 1 when the mode is C (Home only); Phase 3 right after B0; Phase 4 and Phase 5 Step 3b, only when U1 != A"
depends-on: [elicitation-track-b]
priority: P1
tags: [user-level, home-folder, personal-defaults, instruction-files, risk-tiers]
---

# User-level Instruction Files (Home Folder)

> An opt-in add-on to a workspace build (Modes A and B), or the whole job in
> Mode C (Home only). A **user-level instruction file** lives in the user's
> home folder and loads in **every project** on the machine, so it carries
> personal defaults only. The workspace's own entry files are still generated
> complete (Method Y) and never rely on it.

## Contents

- Scope boundary
- Verified load facts
- U1-U3 questions (Other runtimes included)
- Mode C - Home only
- Target resolution
- Managed block template
- Write procedure (Home tier) and validation
- Edge Cases
- Later changes (Phase 6)

---

## Scope Boundary

| Belongs in the user-level instruction file | Never belongs there |
|---|---|
| Who the user is: role, expertise, learning goals | Any rule of this project's workflow (phases, routing, memory policy, git rules) |
| Working language and explanation style | Any path into this workspace (`.workflow-references/`, `GIT_WORKFLOW.md`) |
| Habits the user keeps in every project | Tool, stack, or command facts true of this project only |

**Test for every line:** "would this line still be true in a different
project of mine?" If not, it belongs in the project's files, not here.

---

## Verified Load Facts

Checked against the official docs on 2026-11-24 (Claude Code, Codex) and
2026-11-25 (Gemini CLI, Antigravity CLI; Gemini CLI also against its source).
These runtimes change often: re-check when one updates. Items marked *not
stated* are open questions, and the procedure below asks instead of assuming.

| Runtime | Fact | Source |
|---|---|---|
| Claude Code | Loads `~/.claude/CLAUDE.md` **and** the project's `CLAUDE.md`; all files are concatenated, user-level first. On a contradiction Claude "may pick one arbitrarily" | code.claude.com/docs/en/memory |
| Claude Code | Strips block-level HTML comments before loading, so the block markers cost no context | same |
| Claude Code | `/context all` lists the loaded files under "Memory files" | same |
| Claude Code | Whether `CLAUDE_CONFIG_DIR` moves the user-level `CLAUDE.md`: *not stated* (the settings page lists settings, history and plugins only) | code.claude.com/docs/en/settings |
| Codex | Reads its home folder `$CODEX_HOME` (default `~/.codex`): `AGENTS.override.md` if it exists, else `AGENTS.md`; only the first non-empty file is used | developers.openai.com/codex/guides/agents-md |
| Codex | Stops adding instruction files once their combined size reaches `project_doc_max_bytes` (32 KiB default); whether the user-level instruction file counts toward it: *not stated* - treat it as counting | same |
| Codex | Does **not** read `<repo>/.codex/AGENTS.md`: project lookup runs from the project root down to the working directory only | same |
| Gemini CLI | Loads `~/.gemini/GEMINI.md` first, then the workspace's `GEMINI.md` files; all are concatenated and sent with every prompt | github.com/google-gemini/gemini-cli `docs/cli/gemini-md.md` |
| Gemini CLI | `GEMINI_CLI_HOME` replaces the home folder, so the file becomes `$GEMINI_CLI_HOME/.gemini/GEMINI.md` | source: `packages/core/src/utils/paths.ts` (`homedir`), `config/storage.ts` |
| Gemini CLI | `context.fileName` in `settings.json` renames the context file and may list several names; the memory tool writes the **first** name. Whether the global file also loads under the other names: *not stated* | `docs/cli/gemini-md.md`; source `tools/memoryTool.ts` (`getGlobalMemoryFilePath`) |
| Gemini CLI | Its memory tool saves personal preferences into this same file. Current releases edit it like any file; older ones (read at v0.1.22 and v0.5.5) add facts under `## Gemini Added Memories` and end that section at the next line starting `## ` | `docs/tools/memory.md`; `memoryTool.ts` at those tags |
| Gemini CLI | `/memory show` prints the full concatenated context. HTML comments stripped, or a size limit: *not stated* | `docs/cli/gemini-md.md` |
| Antigravity CLI | Reads the **same** `~/.gemini/GEMINI.md`, and also `~/.gemini/AGENTS.md`, `~/.gemini/config/AGENTS.md` and `~/.gemini/config/GEMINI.md`. Rules are cumulative: every file found loads | antigravity.google/docs/rules |
| Antigravity CLI | Truncates any rule file over 24,000 bytes; global and always-on rules share a 20,000-token budget | same |
| Antigravity CLI | `/context` lists the loaded system files by path. A variable that moves `~/.gemini`: *not stated* | antigravity.google/docs/cli/commands/context |
| Other runtimes | None ship with this skill, and it makes no network request to find them: the user states the path, and only the O-check proves the runtime loads it | - |

---

## Questions (asked inside Phase 3)

Same gate rules as the main bank: one question per turn, concrete options.

**U1. User-level Instruction Files** *(Modes A and B: ask right after B0, whatever B0 chose; default A in every preset. Mode C: the first question, without option A and without "同时 / Also")*

> **要不要同时设置主目录里的用户级指令文件？ / Also set up a user-level instruction file in your home folder?**
>
> 用户级指令文件放在你的主目录里，会在本机的**每一个项目**中加载，与各项目自己的指令文件一起生效（用户级先加载）。所以它只放个人偏好——你是谁、工作语言、讲解方式、跨项目习惯——绝不放本项目的规则。本项目的指令文件照常完整生成，不依赖它。
> *(A user-level instruction file lives in your home folder and loads in **every project** on this machine, together with each project's own instruction file (user-level first). So it carries personal preferences only - who you are, your working language, how you want explanations, cross-project habits - never this project's rules. This project's instruction files are still generated complete and never rely on it.)*
>
> 文件已存在时，只追加一段带标记的区块，你原有的内容不会被改动；每个文件写入前都会先展示差异并等你确认。
> *(If the file already exists, only a marked section is added and your existing text stays untouched. Every file shows a diff and waits for your confirmation before it is written.)*
>
> A) **不需要 / No** *(default; not offered in Mode C)*
>
> B) **要，选择一个或多个目标 / Yes - pick one or more targets:**
>    - **Claude:** `~/.claude/CLAUDE.md`
>    - **Codex:** `~/.codex/AGENTS.md`, or `$CODEX_HOME/AGENTS.md` when that is set
>    - **Gemini:** `~/.gemini/GEMINI.md` - Gemini CLI 和 Antigravity CLI 都读取它 *(read by both Gemini CLI and Antigravity CLI)*
>    - **其他 / Other:** 说出运行时名称和它读取的文件 *(name the runtime and the file it reads)*

Every target is offered whatever B0 chose: the file belongs to the machine,
not to this project.

**Other targets - one follow-up turn per runtime.** Ask for the runtime's name
and the path of the file it loads in every project. If the user does not know
the path, the agent may suggest one from its own knowledge, labeled
**unverified**, for the user to confirm or correct; never write to a path
nobody confirmed. In the same turn, ask the write gate:

> **它是不是一个普通 Markdown 文件、每次会话都被完整加载、文件开头不需要任何特殊内容？ / Is it a plain Markdown file that this runtime loads whole in every session, with nothing required at its top (no frontmatter, no trigger)?**

Yes: the target is written like the others. No or unsure (a settings screen,
a rules folder that needs frontmatter): nothing is written there - the block
goes to `user-level-personal-defaults.proposed.md` with where to paste it, in
the user's own words. The plan document labels every Other fact
*user-stated, unverified*.

**U2. Personal Defaults Content** *(ask only if U1 != A)*

> **用户级文件里放哪些内容？ / What should the user-level file carry?**
>
> 只写对你所有项目都成立的内容。留空的项会被省略，不会被编造。
> *(Only what holds in every project of yours. Anything you leave blank is omitted, never invented.)*
>
> A) **个人档案 + 沟通方式 / Profile + communication** - your role and expertise, working language, how you want explanations.
>
> B) **A + 跨项目习惯 / A + cross-project habits** - also habits such as commit-message style, file-encoding rules, or tools you prefer everywhere.
>
> C) **自定义 / Custom** - describe the sections you want.

After the answer, ask in **one** follow-up turn for the fields of the chosen
option: role and expertise, working language, explanation style, and (B only)
cross-project habits. Run the scope test on each item before accepting it; an
item that fails is offered to a project's files instead (in Mode C, to the
user, since no project is open).

**U3. Decision Support** *(ask only if U1 != A; default A)*

> **重大决策前，要不要让智能体先听取第二意见？ / Should the agent get a second opinion before a consequential decision?**
>
> 只用于有长期代价的决策——架构、方案、难以撤销的权衡；事实问题、小偏好和有明显默认值的选择都不用。
> *(Only for decisions with a lasting cost - architecture, approach, a trade-off that is hard to undo. Never for questions of fact, small preferences, or choices with an obvious default.)*
>
> A) **不需要 / No** *(default)*
>
> B) **盲审子智能体 / Blind sub-agent review** - 智能体先写下自己的选择，再请一个全新上下文、只读的子智能体在看不到这个选择的情况下独立选择。两者一致且判断明确就继续，并用一句话告诉你；否则把两种立场都交给你。
> *(The agent writes down its own pick, then a read-only sub-agent with a fresh context chooses without seeing it. Same pick and a clear call: it goes ahead and tells you in one line. Otherwise both positions come to you.)*
>
> C) **B + 另一个模型家族 / B + a model from another family** - 两者不一致或难分高下时，你还多一个选项：让另一个模型（例如另一家公司的命令行工具）拿同一份盲审简报参与，智能体权衡后再推荐。
> *(On a disagreement or a close call you also get the option to let another model - e.g. another vendor's CLI - weigh in with the same blind brief; the agent weighs both and recommends.)*
>
> D) **自定义 / Custom** - 描述你自己的规则。 *(Describe your own rule.)*

After B, C or D, ask in **one** follow-up turn for:

- **Reviewer settings** (optional): the model and reasoning effort for the
  Round 1 sub-agent, per runtime and in that runtime's own terms (e.g.
  "Claude Code: model opus, effort xhigh").
- **C only - other models:** each model from another family and how the
  agent reaches it (e.g. "Codex, through the cc-suite plugin"). With targets
  in several families, name one outside each, so every runtime has another
  family to ask.

Both answers are user-stated: never suggest a route as working. D is composed
from the user's words and still passes the scope test.

---

## Mode C - Home Only

Chosen in Phase 1 when the user wants only the user-level instruction files.
No workspace file is created or changed.

| Phase | Mode C |
|---|---|
| 0 | Runs as usual; a missing git is no blocker (nothing here needs it) |
| 1 | Mode C detected |
| 2 | Skipped |
| 3 | U1 (no option A), U2 and U3 only - no preset, no Track A or B. Then confirm a short summary: each target with its path, and the U2 and U3 answers |
| 4 | Plan document with Category C alone; the same confirmation gate |
| 5 | Step 3b alone. In a sandbox, the `.proposed.md` file goes in the current folder |
| 6 | A later personal-defaults change is another Mode C run |

Two checks change, because no project file exists: `wwb_codex_size` takes the
home file alone and reports the budget it leaves for project `AGENTS.md`
files, and the contradiction J-check reads only the user's text outside the
markers (plus, for Gemini, the files Antigravity also loads).

---

## Target Resolution (read-only; run before the Phase 4 plan document)

Load the snippet, then run `wwb_resolve`, passing the path of each Other
target as an argument. It reports every built-in target whether selected or
not; read the lines for the targets U1 selected.

```sh
# POSIX sh. Read-only: reports, never writes. Exit 1 when one file is reached twice.
wwb_resolve() {
  codex_dir="${CODEX_HOME:-$HOME/.codex}"; gem_dir="${GEMINI_CLI_HOME:-$HOME}/.gemini"
  echo "CLAUDE_CONFIG_DIR=${CLAUDE_CONFIG_DIR:-unset} | CODEX_HOME=${CODEX_HOME:-unset} | GEMINI_CLI_HOME=${GEMINI_CLI_HOME:-unset}"
  [ -s "$codex_dir/AGENTS.override.md" ] && echo "codex-override=present" || echo "codex-override=absent"
  if [ -f "$gem_dir/settings.json" ] && grep -q '"fileName"' "$gem_dir/settings.json"; then
    echo "gemini-filename=set"; else echo "gemini-filename=unset"; fi
  [ "$gem_dir" = "$HOME/.gemini" ] || echo "gemini-dirs-differ: Gemini CLI $gem_dir | Antigravity $HOME/.gemini"
  for f in "$HOME/.gemini/AGENTS.md" "$HOME/.gemini/config/AGENTS.md" "$HOME/.gemini/config/GEMINI.md"; do
    [ -f "$f" ] && echo "antigravity-also-loads: $f"
  done
  set -- "$HOME/.claude/CLAUDE.md" "$codex_dir/AGENTS.md" "$gem_dir/GEMINI.md" "$@"
  for f in "$@"; do
    [ -L "$f" ] && echo "symlink: $f"
    if [ -f "$f" ]; then echo "exists: $f ($(wc -c < "$f" | tr -d ' ') bytes)"; else echo "absent: $f"; fi
  done
  rc=0
  while [ "$#" -gt 1 ]; do
    a=$1; shift
    for b in "$@"; do
      if [ "$a" = "$b" ] || { [ -e "$a" ] && [ "$a" -ef "$b" ]; }; then echo "same-file: $a = $b"; rc=1; fi
    done
  done
  return "$rc"
}
```

On Windows (Git Bash or PowerShell), `$HOME` is the user profile folder.
`codex-override=present`, `gemini-filename=set`, a `gemini-dirs-differ` line,
`CLAUDE_CONFIG_DIR` set, a `symlink:` line and a `same-file:` line each change
the plan - see Edge Cases. An `antigravity-also-loads:` line names a file the
contradiction J-check must also read.

---

## Managed Block Template

The block is the only thing this skill ever writes into a user-level
instruction file. Pure ASCII, written runtime-neutrally, and **identical in
every target** when U1 selects more than one. Content comes from U2 and U3
answers only - fabrication prohibited; omit a section whose fields were left
blank.

````markdown
<!-- BEGIN workspace-workflow-builder: personal-defaults -->
## Personal Defaults (Every Project)

These defaults apply in every project on this machine. Where a project's own
instruction file says otherwise, follow the project file.

### About the User
- Role and expertise: <U2 answer>

### Language and Explanations
- Working language: <U2 answer>
- Explanation style: <U2 answer>

[ONLY WHEN U2 = B]
### Cross-Project Habits
- <one habit per bullet, as the user stated it>

[ONLY WHEN U3 = B or C]
### Decision Support
- Before a consequential decision (architecture, approach, a trade-off with
  lasting cost), get a second opinion. Skip it for questions of fact, small
  preferences, and choices with an obvious default: asking on small choices
  wastes time and teaches the user to ignore the offer when it matters.
- Round 1, a blind sub-agent: state your own pick in one line first. Then
  start a read-only sub-agent with a fresh context - never one that inherits
  this conversation, which would carry your lean - on <U3 reviewer settings,
  each naming its runtime, then "elsewhere,"> the strongest model and
  reasoning effort you can choose. Give it a blind brief: the options, the
  constraints, and where the evidence is - not your pick. Ask it to choose,
  give the deciding reason, and rate the call clear or close.
- Same pick, rated clear: go ahead, and tell the user in one line the pick,
  the reason, and that a blind second opinion agreed. A hard-to-reverse
  choice still goes to the user first.
- Otherwise (different picks, or a close call): show the user both positions.
- If you cannot start a fresh-context sub-agent, say so and bring the user
  your pick and its deciding reason.
[ONLY WHEN U3 = C]
- Round 2, another model family: with both positions, also offer "Let
  another model weigh in - deliberate, then recommend." If chosen, give the
  same blind brief to one of these that is not your own family:
  - <model>: <route> (one line per U3 answer)
- Deliberate, do not defer: both reviewers can be wrong. Then go ahead with
  the best combined option, or bring the user a sharper recommendation if it
  is still close.
- If none of them is outside your own family, or none can be reached from
  here, do not offer Round 2: say so and show both positions.

[ONLY WHEN U3 = D]
### Decision Support
- <the user's rule, one step per bullet, in their words>
<!-- END workspace-workflow-builder: personal-defaults -->
````

The precedence line is required: both files load together, and the runtime
itself resolves a contradiction arbitrarily. Keep the block short - it is
re-read on every turn of every project.

Decision Support is written for every target at once, so nothing in it may
assume one runtime. Reviewer settings name their runtime ("on model opus at
effort xhigh in Claude Code; elsewhere, the strongest ..."); with none given,
the line reads "on the strongest model and reasoning effort you can choose".
The two fallback lines are required whenever their round is present: a
runtime without sub-agents, or one whose own family is the only one listed,
then says so instead of acting on a capability it lacks.

---

## Write Procedure - Phase 5 Step 3b (🟠 Home Tier)

Runs after the workspace files are written (Mode C: right after the plan is
confirmed). Targets that `wwb_resolve` reported as one file (`same-file:`) are
one target here: written once. An Other target that failed the write gate
skips this procedure and goes to the paste file, as in a sandbox. For each
remaining U1 target, in order:

1. **Write the checks first.** Load the validation snippet below. Before
   writing, `wwb_check` on the untouched target must already fail on the
   markers line (the block is not there yet) - that is the red bar.
2. **Save a pre-image** outside the workspace and the home folder:
   `PRE=$(mktemp)`, then `cp "$TARGET" "$PRE"` if the target exists (an absent
   target keeps the empty pre-image).
3. **Compose by marker state:**

   | Target state | Action |
   |---|---|
   | Absent | New file containing the block only (create the folder if missing) |
   | Exists, no markers, a `## Gemini Added Memories` line | Insert before that line: the block, one blank line, then the heading. After it, Gemini CLI's older memory tool would save the next fact inside the markers |
   | Exists, no markers | Append one blank line, then the block, at the end |
   | Exists, one BEGIN then one END | Replace the lines between the markers, markers kept. Any line in the old block that this skill did not write (a memory tool may have saved it there) is shown and, on approval, moved below END - never dropped |
   | Any other marker state | Stop - see Edge Cases |

   Edit the file in place (a symlink stays a symlink), keep its line endings
   (CRLF stays CRLF), and write UTF-8 without BOM unless the file already had one.
4. **Show the full diff and confirm per file - even for a new file.** The
   change reaches every project on the machine, so the green-tier auto-write
   never applies here.
5. **Validate** with `wwb_check "$TARGET" "$PRE"` and `wwb_gemini_order "$TARGET"`
   on every target; `wwb_codex_size` on the Codex target (Mode C: the home
   file alone); `wwb_file_cap "$TARGET" 24000` on the Gemini target. Then
   delete `$PRE`. Once every target is written, run `wwb_same_block` over all
   of them when there are two or more.

**Sandbox / CI:** never write to the home folder - a sandbox home is not the
user's. Write the block alone to `user-level-personal-defaults.proposed.md` in
the workspace (Mode C: the current folder), list the target paths, and give
the user this next step for their own machine: rerun Step 3b locally, or,
when the target has no markers yet, append it with
`{ printf '\n'; cat user-level-personal-defaults.proposed.md; } >> ~/.claude/CLAUDE.md`
(same for each target - except a file with a `## Gemini Added Memories` line,
where the block is pasted above that heading), then run the validation snippet.

### Validation

| Rung | Check | On failure |
|---|---|---|
| A | Exactly one BEGIN line, then one END line | Stop; Edge Cases |
| A | Text outside the markers unchanged against the pre-image (ignoring trailing blank lines and the one blank line after END) | Restore from `$PRE`; redo step 3 |
| A | Line endings and byte-order mark unchanged | Rewrite in the file's own style |
| A | Block is pure ASCII | Rewrite the offending line in ASCII |
| A | Block names no workspace path | Move that line to the project's files |
| A | Every target: the block sits before any `## Gemini Added Memories` line | Move the block above that heading; redo step 3 |
| A | Two or more targets: every block identical (line endings aside) | Rewrite all from one composed block |
| A | Codex: the user-level `AGENTS.md` plus the project's root `AGENTS.md` under 32,768 bytes. Mode C: the home file alone, with the bytes it leaves for project files reported | Warn; Edge Cases (combined size) |
| A | Gemini: the target within 24,000 bytes, where Antigravity cuts a rule file | Warn; offer to trim the block, or name the user's own text as the bulk |
| A | U3 != A: the block has one `### Decision Support` line; U3 = A: none | Recompose the block from the U3 answer |
| J | Every block line passes the scope test | Move failing lines to the project's files |
| J | Decision Support: every model, route and setting it names is a U3 answer, each setting names its runtime, and each round present keeps its fallback line | Recompose from the U3 answers; never fill a blank with a guess |
| J | No block line contradicts the user's text outside the markers, the generated project file (Modes A and B), or a file `antigravity-also-loads:` named (Gemini) | Ask which wins; change only the block |
| O | Claude Code: in a new session, `/context all` lists the user-level `CLAUDE.md` under "Memory files" - PASS only with that path quoted | BLOCKED (Requires User Verification) until the user reports it |
| O | Codex: `codex --ask-for-approval never "Summarize the current instructions."` quotes the "Working language" line - PASS only with that line quoted. A model summary is weak evidence; `codex -c log_dir=./.codex-log` and `./.codex-log/codex-tui.log` are stronger | BLOCKED (Requires User Verification) until the user reports it |
| O | Gemini CLI: in a new session, `/memory show` prints the "Working language" line - PASS only with that line quoted. Antigravity CLI: `/context` lists the target's path - PASS only with that path quoted | BLOCKED (Requires User Verification) until the user reports it |
| O | Other: in a new session, the runtime quotes the "Working language" line when asked what its instructions say, or its own command lists the file - PASS only with the line or path quoted. This is the only proof the user-stated path is right | BLOCKED (Requires User Verification) until the user reports it |

#### Validation snippet

```sh
# POSIX sh (bash, zsh, Git Bash on Windows). Read-only: inspects, never writes.
WWB_B='<!-- BEGIN workspace-workflow-builder: personal-defaults -->'
WWB_E='<!-- END workspace-workflow-builder: personal-defaults -->'

# Block lines, markers included; CR stripped.
wwb_block() {
  tr -d '\r' < "$1" | awk -v b="$WWB_B" -v e="$WWB_E" '$0 == b {s = 1} s {print} $0 == e {s = 0}'
}
# Lines outside the markers; CR stripped; trailing blank lines dropped, and the
# one blank line after END (the separator a mid-file insert adds) skipped.
wwb_outside() {
  tr -d '\r' < "$1" | awk -v b="$WWB_B" -v e="$WWB_E" '
    $0 == b {s = 1}
    !s && !(k && $0 == "") {a[++n] = $0}
    {k = 0}
    $0 == e {s = 0; k = 1}
    END {while (n > 0 && a[n] == "") n--; for (i = 1; i <= n; i++) print a[i]}'
}
# Exactly one BEGIN, then exactly one END.
wwb_markers() {
  tr -d '\r' < "$1" | awk -v b="$WWB_B" -v e="$WWB_E" '
    $0 == b {nb++; if (ne) bad = 1}
    $0 == e {ne++; if (!nb) bad = 1}
    END {exit !(nb == 1 && ne == 1 && !bad)}'
}
# Line-ending style: lf, crlf, or mixed. Counted on raw bytes with tr, because
# some awk and grep builds (Git Bash) drop CR before a pattern can see it.
wwb_eol() {
  cr=$(( $(tr -cd '\r' < "$1" | wc -c) )); lf=$(( $(tr -cd '\n' < "$1" | wc -c) ))
  if [ "$cr" -eq 0 ]; then echo lf; elif [ "$cr" -eq "$lf" ]; then echo crlf; else echo mixed; fi
}
wwb_has_bom() { [ "$(head -c 3 "$1" | od -An -tx1 | tr -d ' \n')" = "efbbbf" ]; }

# $1 = target after writing, $2 = its pre-image (empty if it did not exist).
wwb_check() {
  rc=0
  if wwb_markers "$1"; then echo "[OK] markers: one BEGIN, one END, in order"
  else echo "[FAIL] markers: need exactly one BEGIN line, then one END line"; rc=1; fi
  if [ "$(wwb_outside "$1")" = "$(wwb_outside "$2")" ]; then echo "[OK] text outside the markers unchanged"
  else echo "[FAIL] text outside the markers changed"; rc=1; fi
  got=$(wwb_eol "$1"); want=any; [ -s "$2" ] && want=$(wwb_eol "$2")
  if [ "$got" = "$want" ] || { [ "$want" = any ] && [ "$got" != mixed ]; }; then
    echo "[OK] line endings unchanged ($got)"
  else echo "[FAIL] line endings changed: $want -> $got"; rc=1; fi
  a=0; wwb_has_bom "$1" && a=1; p=0; wwb_has_bom "$2" && p=1
  if [ "$a" = "$p" ]; then echo "[OK] byte-order mark unchanged"
  else echo "[FAIL] byte-order mark changed"; rc=1; fi
  if wwb_block "$1" | LC_ALL=C grep -q '[^[:print:][:space:]]'; then
    echo "[FAIL] block is not pure ASCII"; rc=1
  else echo "[OK] block is pure ASCII"; fi
  if wwb_block "$1" | grep -Eq '\.workflow-references/|GIT_WORKFLOW\.md'; then
    echo "[FAIL] block names a workspace path"; rc=1
  else echo "[OK] block names no workspace path"; fi
  return "$rc"
}
# Two or more targets: every block must match the first (line endings aside).
wwb_same_block() {
  first=$(wwb_block "$1"); shift; rc=0
  for f in "$@"; do
    [ "$(wwb_block "$f")" = "$first" ] || { echo "[FAIL] blocks differ: $f"; rc=1; }
  done
  [ "$rc" -eq 0 ] && echo "[OK] blocks identical"
  return "$rc"
}
# Every target: the block must come before any "## Gemini Added Memories" line.
# Gemini CLI's older save_memory ends that section at the next "## " line, so
# a block after the heading would get the next saved fact inside its markers.
wwb_gemini_order() {
  if tr -d '\r' < "$1" | awk -v b="$WWB_B" '
    $0 == "## Gemini Added Memories" && !seen {mem = 1}
    $0 == b {seen = 1; if (mem) bad = 1}
    END {exit bad}'; then echo "[OK] block sits before any '## Gemini Added Memories' line"
  else echo "[FAIL] block sits after '## Gemini Added Memories': the next saved fact lands inside the markers"; return 1; fi
}
# Codex: $1 = home AGENTS.md (or AGENTS.override.md), $2 = project root AGENTS.md.
# Mode C has no project file: pass $1 alone for the budget it leaves.
wwb_codex_size() {
  lim=${3:-32768}
  if [ -z "${2:-}" ]; then
    n=$(( $(wc -c < "$1") ))
    if [ "$n" -lt "$lim" ]; then echo "[OK] home AGENTS.md is $n bytes: $((lim - n)) bytes left for project AGENTS.md files"
    else echo "[WARN] home AGENTS.md alone is $n bytes >= $lim: Codex may drop every project file"; return 1; fi
    return 0
  fi
  total=$(( $(wc -c < "$1") + $(wc -c < "$2") ))
  if [ "$total" -lt "$lim" ]; then echo "[OK] combined AGENTS.md size $total < $lim bytes"
  else echo "[WARN] combined AGENTS.md size $total >= $lim bytes: Codex may drop the project file"; return 1; fi
}
# A one-file cap: $1 = file, $2 = limit in bytes (Gemini target: 24000).
wwb_file_cap() {
  n=$(( $(wc -c < "$1") ))
  if [ "$n" -le "$2" ]; then echo "[OK] $1 is $n bytes, within the $2-byte cap"
  else echo "[WARN] $1 is $n bytes, over the $2-byte cap: the runtime may cut it"; return 1; fi
}
```

---

## Edge Cases

| Situation | Action |
|---|---|
| `AGENTS.override.md` is non-empty in the Codex home folder | Codex ignores `AGENTS.md` there. Say so, then ask: write the block into `AGENTS.override.md`, or skip Codex. Never write `AGENTS.md` silently |
| `CLAUDE_CONFIG_DIR` is set | The docs do not state whether the user-level `CLAUDE.md` moves with it. Ask which path to use; the `/context all` O-check settles it |
| `CODEX_HOME` is set | Use `$CODEX_HOME/AGENTS.md` (documented) |
| Target is a symlink (e.g. a dotfiles manager) | Edit in place through the link; never replace the link with a new file. Name the real path in the diff header |
| Marker state is not zero pairs or one ordered pair | Stop. Show each marker line with its line number and ask which block to keep. Never guess |
| User's text outside the markers contradicts a block line | Show both lines; ask which wins; change only the block - text outside the markers is the user's |
| A U2 item fails the scope test | Offer it to this project's files; never write it into the user-level file |
| U3 != A, and a target runtime may have no sub-agents (an Other target, or the user is unsure) | Say so at U3: there, Round 1 falls back to the agent's pick and its deciding reason. Never state that a runtime has sub-agents |
| U3 = C, and the only model listed shares a target's family (e.g. Codex listed, Codex a target) | Say so at U3 and offer to name one outside that family; otherwise that runtime skips Round 2, as the block's fallback line says |
| A stated fact cannot be written in ASCII (e.g. a name in its own script) | Ask: transliterate, or keep it and record the ASCII check as FAILED (accepted by the user) - never PASS |
| Codex combined size check warns | Offer two fixes: trim the block, or raise `project_doc_max_bytes` in the user's Codex `config.toml`. This skill does not edit `config.toml` itself |
| Sandbox / CI | Never write the home folder; emit `user-level-personal-defaults.proposed.md` plus the next step (Write Procedure) |
| `gemini-filename=set`, or the project's `.gemini/settings.json` sets `context.fileName` | Gemini CLI's memory tool writes the first name listed; the docs do not say which global names load. Show the setting, ask which file gets the block; the `/memory show` O-check settles it |
| `gemini-dirs-differ` (`GEMINI_CLI_HOME` set) | Gemini CLI reads `$GEMINI_CLI_HOME/.gemini`; Antigravity's docs name no such variable. Ask which CLI the block is for; for both, write both files - two targets, one block |
| `antigravity-also-loads:` lines | Antigravity loads those files beside `GEMINI.md`. Read them for the contradiction J-check; never put the block in them too - it would load twice |
| `same-file:` line | One file reached by two targets (a dotfiles symlink, or an Other path equal to a built-in one). Write it once and name both runtimes in the diff header. When only one of the two was selected, say the other runtime gets the block too |
| Other target: the user does not know the path | Suggest one from your own knowledge, labeled **unverified**; write only to a path the user confirmed |
| Other target fails the write gate, or the user is unsure | Write nothing there; emit `user-level-personal-defaults.proposed.md` and repeat where the user said it goes |
| User asks for `<repo>/.codex/AGENTS.md` | Codex does not read it (Verified Load Facts). Keep `AGENTS.md` at the project root and say why |

---

## Later Changes (Phase 6)

A change to the personal defaults is a Mode C run: it edits only the lines
between the markers, through the same Step 3b procedure - pre-image, diff,
per-file confirmation, validation. A workspace sync never touches a user-level instruction file, and
a personal-defaults sync never touches the workspace.
