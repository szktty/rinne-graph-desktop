#!/usr/bin/env bash
# apply_license_header.sh
#
# Prepends a license header to all hand-written Dart source files.
# Skips files that already contain the header, and auto-generated files
# (*.g.dart, *.freezed.dart) and files under .dart_tool/.
#
# Usage:
#   ./scripts/apply_license_header.sh          # dry-run (preview only)
#   ./scripts/apply_license_header.sh --apply  # write changes

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

HEADER='/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */'

# Marker used to detect whether the header is already present
MARKER="SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial"

DRY_RUN=true
if [[ "${1:-}" == "--apply" ]]; then
  DRY_RUN=false
fi

applied=0
skipped_generated=0
skipped_already=0

while IFS= read -r -d '' file; do
  # Skip auto-generated files
  if [[ "$file" == *.g.dart || "$file" == *.freezed.dart ]]; then
    skipped_generated=$((skipped_generated + 1))
    continue
  fi

  # Skip files that already have the header
  if grep -qF "$MARKER" "$file"; then
    skipped_already=$((skipped_already + 1))
    continue
  fi

  if $DRY_RUN; then
    echo "[DRY-RUN] would apply: $file"
  else
    tmp=$(mktemp)
    printf '%s\n\n' "$HEADER" | cat - "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "[APPLIED] $file"
  fi
  applied=$((applied + 1))

done < <(find "$REPO_ROOT" \
  \( \
    -name ".dart_tool" -o \
    -name "build" -o \
    -name ".git" \
  \) -prune -o \
  -name "*.dart" -print0)

echo ""
echo "=== Summary ==="
if $DRY_RUN; then
  echo "Mode          : DRY-RUN (no files written)"
  echo "Would apply   : $applied"
else
  echo "Mode          : APPLY"
  echo "Applied       : $applied"
fi
echo "Already tagged: $skipped_already"
echo "Generated     : $skipped_generated"

if $DRY_RUN && [[ $applied -gt 0 ]]; then
  echo ""
  echo "Run with --apply to write changes:"
  echo "  ./scripts/apply_license_header.sh --apply"
fi
