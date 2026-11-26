#!/bin/sh
# build-single-file.sh - Build the single-file distribution edition of the
# workspace-workflow-builder skill by concatenating SKILL.md with all
# reference modules as appendices.
#
# Usage:   sh scripts/build-single-file.sh
# Output:  dist/SKILL_workspace_workflow_builder_single.md
#
# The output is a self-contained prompt for platforms that consume a single
# file (e.g. OpenAI Codex CLI, Google Antigravity). Pointer lines in the body
# ("read references/<file>.md") map to the appendix of the same title; the
# Edge Cases table in SKILL.md documents this mapping for the consuming agent.

set -eu

cd "$(dirname "$0")/.."

OUT="dist/SKILL_workspace_workflow_builder_single.md"
mkdir -p dist

append_appendix() {
  # $1 = appendix letter, $2 = source file
  printf '\n---\n\n# Appendix %s - source: %s\n\n' "$1" "$2" >> "$OUT"
  cat "$2" >> "$OUT"
}

cp SKILL.md "$OUT"

printf '\n---\n\n# Appendices (Single-File Edition)\n\n' >> "$OUT"
printf 'Each appendix below is the verbatim content of one reference module.\n' >> "$OUT"
printf 'Whenever the body says "read references/<name>.md", read the appendix\n' >> "$OUT"
printf 'sourced from that file instead.\n' >> "$OUT"

append_appendix "A" "references/environment-setup.md"
append_appendix "B" "references/elicitation-questions.md"
append_appendix "C" "references/elicitation-track-b.md"
append_appendix "D" "references/project-file-templates.md"
append_appendix "E" "references/agent-file-templates.md"
append_appendix "F" "references/entry-file-templates.md"
append_appendix "G" "references/memory-template.md"
append_appendix "H" "references/change-logging-template.md"
append_appendix "I" "references/phase-2-branch-templates.md"
append_appendix "J" "references/phase-2-branch-s.md"
append_appendix "K" "references/phase-2-branch-e.md"
append_appendix "L" "references/phase-2-branch-p.md"
append_appendix "M" "references/phase-2-branch-d.md"
append_appendix "N" "references/phase-2-branch-c.md"
append_appendix "O" "references/phase-2-branch-o.md"
append_appendix "P" "references/git-workflow-template.md"
append_appendix "Q" "references/git-workflow-team.md"
append_appendix "R" "references/visual-presentation.md"
append_appendix "S" "references/execution-steps.md"
append_appendix "T" "references/print-output.md"
append_appendix "U" "references/user-level-files.md"

# Sanity checks
fence_count=$(grep -c '^```' "$OUT" || true)
if [ $((fence_count % 2)) -ne 0 ]; then
  echo "WARNING: odd number of fence lines ($fence_count) in $OUT" >&2
  exit 1
fi

lines=$(wc -l < "$OUT")
echo "Built $OUT ($lines lines, fence lines: $fence_count)"
