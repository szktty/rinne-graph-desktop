#!/usr/bin/env bash
# PreToolUse hook for Edit/Write.
# Blocks manual edits to generated files (*.g.dart, *.freezed.dart).
# Per CLAUDE.md: generated files must be regenerated via `melos run gen:all`,
# never hand-edited.
#
# Reads the tool call JSON from stdin. Exits 2 (with a message on stderr) to
# block the call; exits 0 to allow it.

set -euo pipefail

input="$(cat)"

# Extract the target file path. Edit/Write use tool_input.file_path.
file_path="$(printf '%s' "$input" | /usr/bin/python3 -c \
  'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' \
  2>/dev/null || true)"

if [[ -z "$file_path" ]]; then
  exit 0
fi

case "$file_path" in
  *.g.dart|*.freezed.dart)
    echo "Blocked: '$file_path' is a generated file. Do not edit it by hand." >&2
    echo "Edit the source annotation instead, then run: melos run gen:all" >&2
    exit 2
    ;;
esac

exit 0
