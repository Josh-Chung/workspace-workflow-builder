#!/bin/sh
# Rung O check for the two snippets shipped in references/user-level-files.md:
# the resolution snippet ("## Target Resolution") and the validation snippet
# ("#### Validation snippet").
#
# Extracts each snippet verbatim from the module -- never a copy kept here, so
# the test cannot pass against code the skill does not ship -- then runs it
# against fixture files in a private temp directory. Each case asserts a named
# literal in the snippet's output and passes only when that literal is seen.
# The must-fail cases (tampered text, duplicate markers, mixed line endings,
# a BOM, non-ASCII, a workspace path, a block after Gemini's memory heading,
# one file reached twice) prove the snippets can say FAIL.
#
# Never touches the real ~/.claude, ~/.codex or ~/.gemini: the snippets only
# read the files they are given, HOME points into the temp directory for the
# run, and the runtime home variables are unset.
# Run from the package root: sh tests/test_user_level_snippet.sh
# Declared in CHECKS, so check-artifact.sh A11 runs it on every package check.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
MOD="$HERE/../references/user-level-files.md"
[ -f "$MOD" ] || { echo "FAIL  module not found: $MOD"; exit 1; }

W=$(mktemp -d 2>/dev/null) || { echo "BLOCKED  mktemp not found on this host"; exit 127; }
trap 'rm -rf "$W"' EXIT
trap 'rm -rf "$W"; exit 130' INT
trap 'rm -rf "$W"; exit 143' TERM
HOME="$W/home"; mkdir "$HOME"; export HOME
unset CODEX_HOME GEMINI_CLI_HOME CLAUDE_CONFIG_DIR

SNIP="$W/snippet.sh"
awk '/^#### Validation snippet/{h=1; next} h && /^```sh\r?$/{p=1; next} p && /^```\r?$/{exit} p{print}' \
  "$MOD" | tr -d '\r' > "$SNIP"
[ -s "$SNIP" ] || { echo "FAIL  no validation snippet extracted from $MOD"; exit 1; }
. "$SNIP"

# The resolution snippet: the first sh fence inside "## Target Resolution".
# A missing one is not fatal here -- the resolution cases below fail instead.
RES="$W/resolve.sh"
awk '/^## Target Resolution/{h=1; next} h && !p && /^## /{exit} h && /^```sh\r?$/{p=1; next} p && /^```\r?$/{exit} p{print}' \
  "$MOD" | tr -d '\r' > "$RES"
if [ -s "$RES" ]; then . "$RES"; else echo "note  no sh fence under '## Target Resolution' in $MOD"; fi

pass=0; fail=0

crlf() { awk '{ printf "%s\r\n", $0 }' "$1"; }

cat > "$W/block" <<'EOF'
<!-- BEGIN workspace-workflow-builder: personal-defaults -->
## Personal Defaults (every project)

These defaults apply in every project on this machine. Where a project's own
instruction file says otherwise, follow the project file.

- Working language: English, short sentences.
<!-- END workspace-workflow-builder: personal-defaults -->
EOF
sed 's/short sentences/plain words/' "$W/block" > "$W/block2"
printf '# My notes\n\nKeep answers short.\n' > "$W/mine"

# expect <case> <want: pass|fail> <literal> <cmd...>
expect() {
  name=$1; want=$2; lit=$3; shift 3
  out=$("$@" 2>&1); rc=$?
  got=pass; [ "$rc" -eq 0 ] || got=fail
  if [ "$got" = "$want" ] && printf '%s\n' "$out" | grep -qF -- "$lit"; then
    echo "ok    $name -> $got, saw \"$lit\""; pass=$((pass + 1))
  else
    echo "FAIL  $name -> got $got (want $want), literal \"$lit\" seen: $(printf '%s\n' "$out" | grep -cF -- "$lit")"
    printf '%s\n' "$out" | sed 's/^/        /'
    fail=$((fail + 1))
  fi
}

# 1. absent target: pre-image is empty, post is the block alone
: > "$W/c1.pre"; cp "$W/block" "$W/c1.post"
expect "1 new file"                 pass "[OK] text outside the markers unchanged" wwb_check "$W/c1.post" "$W/c1.pre"

# 2. existing LF file without markers: append after one blank line
cp "$W/mine" "$W/c2.pre"; { cat "$W/mine"; echo; cat "$W/block"; } > "$W/c2.post"
expect "2 append to LF file"        pass "[OK] markers: one BEGIN, one END, in order" wwb_check "$W/c2.post" "$W/c2.pre"

# 3. existing CRLF file: block appended in CRLF too
crlf "$W/mine" > "$W/c3.pre"; { crlf "$W/mine"; printf '\r\n'; crlf "$W/block"; } > "$W/c3.post"
expect "3 append to CRLF file"      pass "[OK] line endings unchanged (crlf)" wwb_check "$W/c3.post" "$W/c3.pre"

# 4. CRLF file, block appended in LF: mixed endings must fail
{ crlf "$W/mine"; echo; cat "$W/block"; } > "$W/c4.post"
expect "4 LF block in CRLF file"    fail "[FAIL] line endings changed" wwb_check "$W/c4.post" "$W/c3.pre"

# 5. re-run: replace the block content, keep everything outside it
cp "$W/c2.post" "$W/c5.pre"; { cat "$W/mine"; echo; cat "$W/block2"; } > "$W/c5.post"
expect "5 re-run replaces block"    pass "[OK] markers: one BEGIN, one END, in order" wwb_check "$W/c5.post" "$W/c5.pre"

# 6. tampered: a line outside the markers changed
sed 's/Keep answers short/Keep answers long/' "$W/c2.post" > "$W/c6.post"
expect "6 outside text tampered"    fail "[FAIL] text outside the markers changed" wwb_check "$W/c6.post" "$W/c2.pre"

# 7. duplicate block (append on re-run instead of replace)
{ cat "$W/c2.post"; echo; cat "$W/block"; } > "$W/c7.post"
expect "7 duplicate markers"        fail "[FAIL] markers" wwb_check "$W/c7.post" "$W/c2.pre"

# 8. END before BEGIN
awk 'NR==1{first=$0; next} {print} END{print first}' "$W/block" > "$W/c8.post"
expect "8 markers out of order"     fail "[FAIL] markers" wwb_check "$W/c8.post" "$W/c1.pre"

# 9. non-ASCII inside the block (an em dash, built with printf so this file stays ASCII)
dash=$(printf '\342\200\224')
sed "s/short sentences/short sentences $dash always/" "$W/block" > "$W/c9.post"
expect "9 non-ASCII in block"       fail "[FAIL] block is not pure ASCII" wwb_check "$W/c9.post" "$W/c1.pre"

# 10. a workspace path inside the block
sed 's/short sentences/read .workflow-references\/GIT_WORKFLOW.md first/' "$W/block" > "$W/c10.post"
expect "10 workspace path in block" fail "[FAIL] block names a workspace path" wwb_check "$W/c10.post" "$W/c1.pre"

# 11. a BOM added to a file that had none
{ printf '\357\273\277'; cat "$W/c2.post"; } > "$W/c11.post"
expect "11 BOM introduced"          fail "[FAIL] byte-order mark changed" wwb_check "$W/c11.post" "$W/c2.pre"

# 12-13. both files selected: blocks must be byte-identical
expect "12 identical blocks"        pass "[OK] blocks identical" wwb_same_block "$W/c2.post" "$W/c3.post"
expect "13 differing blocks"        fail "[FAIL] blocks differ" wwb_same_block "$W/c2.post" "$W/c5.post"

# 14-15. Codex combined size against the 32 KiB default cap
head -c 20000 /dev/zero | tr '\0' 'a' > "$W/home.agents"
head -c 13000 /dev/zero | tr '\0' 'b' > "$W/proj.agents"
expect "14 combined over 32 KiB"    fail "[WARN] combined AGENTS.md size" wwb_codex_size "$W/home.agents" "$W/proj.agents"
expect "15 combined under 32 KiB"   pass "[OK] combined AGENTS.md size" wwb_codex_size "$W/c2.post" "$W/proj.agents"

# 16. the documented red bar: an untouched target fails on the markers line
expect "16 red bar before writing"  fail "[FAIL] markers: need exactly one BEGIN line" wwb_check "$W/c2.pre" "$W/c2.pre"

# 17-18. three or more targets: every block must match the first
expect "17 three identical blocks"  pass "[OK] blocks identical" wwb_same_block "$W/c2.post" "$W/c3.post" "$W/c1.post"
expect "18 third block differs"     fail "[FAIL] blocks differ" wwb_same_block "$W/c2.post" "$W/c3.post" "$W/c5.post"

# 19-20. a one-file cap (Antigravity truncates a rule file over 24,000 bytes)
head -c 25000 /dev/zero | tr '\0' 'g' > "$W/big.gemini"
expect "19 file over its cap"       fail "[WARN] $W/big.gemini is 25000 bytes" wwb_file_cap "$W/big.gemini" 24000
expect "20 file under its cap"      pass "[OK] $W/c2.post is" wwb_file_cap "$W/c2.post" 24000

# 21-22. Mode C: no project AGENTS.md, so report the budget the home file leaves
head -c 33000 /dev/zero | tr '\0' 'c' > "$W/huge.agents"
expect "21 home only, budget left"  pass "bytes left for project AGENTS.md files" wwb_codex_size "$W/c2.post"
expect "22 home only, over the cap" fail "[WARN] home AGENTS.md alone is 33000 bytes" wwb_codex_size "$W/huge.agents"

# 23-24. Gemini: the block must sit before "## Gemini Added Memories", or an
# older save_memory (v0.1.22-v0.5.5) inserts the next fact inside the markers
printf '## Gemini Added Memories\n- fact one\n' > "$W/mem"
{ cat "$W/block"; echo; cat "$W/mem"; } > "$W/c23.post"
{ cat "$W/mem"; echo; cat "$W/block"; } > "$W/c24.post"
expect "23 block before memories"   pass "[OK] block sits before" wwb_gemini_order "$W/c23.post"
expect "24 block after memories"    fail "[FAIL] block sits after '## Gemini Added Memories'" wwb_gemini_order "$W/c24.post"

# 25-28. inserted mid-file, before that heading: the block, one blank line, the heading
{ cat "$W/mine"; echo; cat "$W/mem"; } > "$W/c25.pre"
{ cat "$W/mine"; echo; cat "$W/block"; echo; cat "$W/mem"; } > "$W/c25.post"
expect "25 mid-file insert"         pass "[OK] text outside the markers unchanged" wwb_check "$W/c25.post" "$W/c25.pre"
{ cat "$W/mine"; cat "$W/mem"; } > "$W/c26.pre"
{ cat "$W/mine"; cat "$W/block"; echo; cat "$W/mem"; } > "$W/c26.post"
expect "26 mid-file, no blank"      pass "[OK] text outside the markers unchanged" wwb_check "$W/c26.post" "$W/c26.pre"
{ cat "$W/mine"; echo; cat "$W/block2"; echo; cat "$W/mem"; } > "$W/c27.post"
expect "27 mid-file re-run"         pass "[OK] text outside the markers unchanged" wwb_check "$W/c27.post" "$W/c25.post"
{ cat "$W/mine"; cat "$W/block"; echo; cat "$W/mem"; } > "$W/c28.post"
expect "28 user's blank line lost"  fail "[FAIL] text outside the markers changed" wwb_check "$W/c28.post" "$W/c25.pre"

# 29-35. the resolution snippet, against the fake HOME
res_gemini_home() { GEMINI_CLI_HOME="$W/gh"; export GEMINI_CLI_HOME; wwb_resolve; }
expect "29 Gemini default target"   pass "absent: $HOME/.gemini/GEMINI.md" wwb_resolve
expect "30 GEMINI_CLI_HOME moves it" pass "absent: $W/gh/.gemini/GEMINI.md" res_gemini_home
expect "31 Antigravity dir differs" pass "gemini-dirs-differ" res_gemini_home
mkdir -p "$HOME/.gemini" "$HOME/.claude" "$HOME/.codex"
printf '{\n  "context": { "fileName": ["AGENTS.md", "GEMINI.md"] }\n}\n' > "$HOME/.gemini/settings.json"
expect "32 context.fileName set"    pass "gemini-filename=set" wwb_resolve
cp "$W/mine" "$HOME/.gemini/AGENTS.md"
expect "33 Antigravity extra file"  pass "antigravity-also-loads: $HOME/.gemini/AGENTS.md" wwb_resolve
expect "34 Other names a known path" fail "same-file: $HOME/.codex/AGENTS.md" wwb_resolve "$HOME/.codex/AGENTS.md"
cp "$W/mine" "$HOME/.claude/CLAUDE.md"
expect "35 one file, two spellings" fail "same-file: $HOME/.claude/CLAUDE.md" wwb_resolve "$HOME/.claude/./CLAUDE.md"

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
