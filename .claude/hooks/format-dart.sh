#!/usr/bin/env bash
# PostToolUse hook for Edit/Write.
# Auto-formats Dart files after they are edited, matching the CI check
# (`dart format --set-exit-if-changed`) so formatting drift never reaches CI.
#
# Skips generated files (handled by the block-generated-edits hook) and
# non-Dart files. Reads the tool call JSON from stdin. Always exits 0:
# formatting is best-effort and must never block the workflow.

set -uo pipefail

input="$(cat)"

file_path="$(printf '%s' "$input" | /usr/bin/python3 -c \
  'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' \
  2>/dev/null || true)"

# Only format real Dart source files.
case "$file_path" in
  *.g.dart|*.freezed.dart) exit 0 ;;
  *.dart) ;;
  *) exit 0 ;;
esac

[[ -f "$file_path" ]] || exit 0

# Prefer the FVM-pinned SDK; fall back to whatever `dart` is on PATH.
if command -v fvm >/dev/null 2>&1 && [[ -f "${CLAUDE_PROJECT_DIR:-.}/.fvmrc" ]]; then
  (cd "${CLAUDE_PROJECT_DIR:-.}" && fvm dart format "$file_path") >/dev/null 2>&1 || true
elif command -v dart >/dev/null 2>&1; then
  dart format "$file_path" >/dev/null 2>&1 || true
fi

exit 0
