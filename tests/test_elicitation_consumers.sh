#!/bin/sh
# Rung A check: every elicitation question has a reader.
#
# A question no generation template reads is dead wiring: the user is asked,
# the confirmation summary may even echo the answer, and the workspace comes
# out the same whatever they chose. B4 shipped that way until 2026-11-25, and
# B8 and B10 until this check found them.
#
# Lists every question ID defined in the two question banks
# (references/elicitation-questions.md, references/elicitation-track-b.md)
# and requires each to be named in at least one other reference file -- the
# templates and steps that turn answers into files. SKILL.md does not count:
# its preset and pruning tables name every ID without reading any answer,
# which is how B4 hid. A range such as "B0-B10" does not count either.
#
# The add-on questions (U1, U2, ...) live in references/user-level-files.md,
# which both asks and reads them: there, a reader is any line outside that
# module's "## Questions" section, or another reference file.
#
# Presence, not proof: a template can name B8 and still ignore an option.
# Whether each option produces what it promises stays a J-check. The fixture
# cases prove the check can say FAIL.
# Run from the package root: sh tests/test_elicitation_consumers.sh
# Declared in CHECKS, so check-artifact.sh A11 runs it on every package check.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
REF="$HERE/../references"
[ -d "$REF" ] || { echo "FAIL  references/ not found: $REF"; exit 1; }

BANKS="elicitation-questions.md elicitation-track-b.md"

# consumers <dir>: one line per question ID; exit 1 if any ID has no reader.
consumers() {
  dir=$1; bad=0
  ids=$(for b in $BANKS; do [ -f "$dir/$b" ] && tr -d '\r' < "$dir/$b"; done |
    sed -n 's/^\*\*\([A-Z][0-9][0-9]*\(-[a-z][a-z]*\)\{0,1\}\)\. .*/\1/p' | sort -u)
  [ -n "$ids" ] || { echo "FAIL  no question IDs found in $dir"; return 1; }
  for id in $ids; do
    n=0
    for f in "$dir"/*.md; do
      case " $BANKS " in *" ${f##*/} "*) continue ;; esac
      grep -qE "(^|[^A-Za-z0-9-])$id([^A-Za-z0-9-]|\$)" "$f" && n=$((n + 1))
    done
    if [ "$n" -gt 0 ]; then echo "ok    $id read by $n file(s)"
    else echo "FAIL  $id is asked but no template reads it"; bad=1; fi
  done
  return "$bad"
}

# u_consumers <dir>: the same check for the add-on questions in
# user-level-files.md; the module's own Questions section does not count.
u_consumers() {
  dir=$1; mod="$dir/user-level-files.md"; bad=0
  [ -f "$mod" ] || { echo "FAIL  no user-level-files.md in $dir"; return 1; }
  rest="$W/u-rest.md"
  tr -d '\r' < "$mod" | awk '/^## Questions/{q = 1; next} q && /^## /{q = 0} !q' > "$rest"
  ids=$(tr -d '\r' < "$mod" | sed -n 's/^\*\*\(U[0-9][0-9]*\)\. .*/\1/p' | sort -u)
  [ -n "$ids" ] || { echo "FAIL  no U question IDs found in $mod"; return 1; }
  for id in $ids; do
    n=0
    for f in "$rest" "$dir"/*.md; do
      case " user-level-files.md $BANKS " in *" ${f##*/} "*) continue ;; esac
      grep -qE "(^|[^A-Za-z0-9-])$id([^A-Za-z0-9-]|\$)" "$f" && n=$((n + 1))
    done
    if [ "$n" -gt 0 ]; then echo "ok    $id read by $n file(s)"
    else echo "FAIL  $id is asked but no template reads it"; bad=1; fi
  done
  return "$bad"
}

W=$(mktemp -d 2>/dev/null) || { echo "BLOCKED  mktemp not found on this host"; exit 127; }
trap 'rm -rf "$W"' EXIT
trap 'rm -rf "$W"; exit 130' INT
trap 'rm -rf "$W"; exit 143' TERM

pass=0; fail=0
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

# fixture <name>: a question bank defining Z1, Z2 and Z1-extra
fixture() {
  mkdir "$W/$1"
  printf '**Z1. First**\n\n**Z1-extra. Sub-question**\n' > "$W/$1/elicitation-questions.md"
  printf '**Z2. Second**\r\n' > "$W/$1/elicitation-track-b.md"
}

# 1. the shipped references: every question has a reader
expect "1 shipped question banks"      pass "ok    B10 read by" consumers "$REF"

# 2. Z2 named only in a range, and inside its own bank: still unread
fixture f2
printf '[Z1 = A ONLY]\n[Z1-extra = B ONLY]\nQuestions Z0-Z2 live in the banks.\n' > "$W/f2/tpl.md"
expect "2 range mention is not a read" fail "FAIL  Z2 is asked but no template reads it" consumers "$W/f2"

# 3. Z10 and Z1-extra are not Z1
fixture f3
printf '[Z10 = A ONLY]\n[Z1-extra = B ONLY]\n<Z2 = C: text>\n' > "$W/f3/tpl.md"
expect "3 prefix is not a read"        fail "FAIL  Z1 is asked but no template reads it" consumers "$W/f3"

# 4. every ID named by a template: pass
fixture f4
printf '[Z1 = A ONLY]\n[Z1-extra = B ONLY]\n<Z2 = C: text>\n' > "$W/f4/tpl.md"
expect "4 every question read"         pass "ok    Z1-extra read by 1 file(s)" consumers "$W/f4"

# 5. a bank with no question IDs at all must not pass silently
mkdir "$W/f5"; printf 'no questions here\n' > "$W/f5/elicitation-questions.md"
expect "5 empty bank"                  fail "FAIL  no question IDs found" consumers "$W/f5"

# 6. the shipped add-on module: every U question has a reader
expect "6 shipped add-on questions"    pass "ok    U2 read by" u_consumers "$REF"

# ufixture <name>: an add-on module asking U1 and U2; U1 is read below its
# Questions section, U2 is named only inside it
ufixture() {
  mkdir "$W/$1"
  printf '## Questions\r\n\r\n**U1. First**\r\n\r\n**U2. Second** *(ask only if U1 != A)*\r\n\r\n## Write\r\n\r\nEach U1 target.\r\n' \
    > "$W/$1/user-level-files.md"
}

# 7. named only inside its own Questions section: still unread
ufixture f7
expect "7 own question text is no read" fail "FAIL  U2 is asked but no template reads it" u_consumers "$W/f7"

# 8. U2 read by another reference file: pass
ufixture f8
printf '%s\n' '- Role: <U2 answer>' > "$W/f8/tpl.md"
expect "8 every add-on question read"  pass "ok    U2 read by 1 file(s)" u_consumers "$W/f8"

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
