# CLAUDE.md

RinneGraph — a graph-based personal knowledge management desktop app (Flutter/Dart,
Melos monorepo, macOS primary). See `docs/architecture/monorepo_overview.md` for
package layout, dependency rules, Riverpod/freezed patterns, and custom library
ownership (`ChiffonDB`, `plough`, `fonde-ui` — fix the library, not the app).

## Non-negotiables

- **Build after every change**: `cd apps/desktop && flutter build macos`. One file at a
  time — never batch edits before building. `flutter analyze` is not build validation.
- **Read the whole file before editing it.** No guessed re-edits after a failed edit.
- **Never commit without user confirmation.** A passing build is necessary but not
  sufficient; the user must verify runtime behavior first. If verification is blocked,
  leave the work uncommitted and say so.
- **Regenerate after freezed/Riverpod changes**: `melos run gen:all`. Never hand-edit
  `.g.dart` / `.freezed.dart`.
- **Root cause over symptom.** Trace upstream (often another package) before patching.
  Stop and explain after 2 failed fix attempts.
- **Check dependents before touching `packages/core/`** — and trace both directions of a
  provider chain.
- Plan mode for anything touching 3+ files or crossing package boundaries.

Full text: `docs/development/working_agreements.md` (also covers commands, session
logging in `../rinne-graph-desktop-private/`, and context-limit handoff).

## Read before implementing

- Multi-package change → `docs/architecture/data_flows.md`, then
  `docs/architecture/data_flow_concerns.md`
- Stack operations → `docs/stack/stack_api_architecture.md`;
  import/export → `docs/stack/stack_exchange_format_specification.md`
- UI / components → `docs/design/03-components.md`, `docs/design/04-implementation.md`
- Color / theme → `docs/design/02-design-tokens.md`,
  `docs/design/09-color-design-guidelines.md`
- Dialogs / panels → `docs/design/13-panel-layout-guidelines.md`,
  `docs/design/15-warning-error-dialog-guidelines.md`
- `ChiffonDB` / `plough` / `kiri_check` → check `llms/` for context files first

## Licensing

Dual-licensed: **AGPL-3.0-only OR a commercial license**. The AGPLv3 is defensive — it
exists to keep the commercial option viable, not as a preference for copyleft.

- **Every new source file needs the SPDX header** used by existing files: copyright line,
  `SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial`, and the commercial
  contact. Copy it from a neighboring file.
- **New dependencies must be permissively licensed** (MIT/BSD/Apache-2.0). A GPL/AGPL
  dependency breaks the commercial license even though this project is AGPLv3 — flag it
  rather than adding it.
- Don't propose relicensing or dropping the CLA.

## Language

All source code, comments, and documentation in English. Communicate with the user in
their preferred language.
