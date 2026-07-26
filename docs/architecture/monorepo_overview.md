# Monorepo Overview

Reference for the repository structure and the architectural patterns that span
packages. `CLAUDE.md` links here instead of restating this content.

## Project Overview

RinneGraph is a graph-based personal knowledge management desktop app (alpha
stage). Built with Flutter/Dart, it uses a property graph database to let users
organize knowledge as interconnected nodes and links within portable "stacks."

- **Platforms**: macOS (primary), Windows (experimental)
- **License**: dual-licensed, AGPL-3.0-only OR commercial (see below)

## Licensing

RinneGraph is dual-licensed:

- **[AGPLv3](../../LICENSE)** for open-source use
- **Commercial license** (planned) for those who need to avoid the AGPLv3
  obligations — e.g. source disclosure for network-deployed services, or
  internal enterprise use. Inquiries: contact@szktty.jp

The AGPLv3 choice is **defensive**: it protects the ability to offer the
commercial license, rather than expressing a preference for copyleft as such.
Two practical consequences follow:

1. **Copyright must stay consolidated.** Contributions are accepted under a
   [CLA](https://gist.github.com/szktty/098a5717a813146dd797e557400a31c1); see
   [`../../CONTRIBUTING.md`](../../CONTRIBUTING.md). Without it the work could
   not be relicensed commercially.
2. **Dependencies must be permissively licensed** (MIT / BSD / Apache-2.0).
   Pulling in a GPL or AGPL dependency would make the commercial license
   impossible to grant, even though this project is itself AGPLv3. This is a
   stricter bar than "AGPLv3-compatible" — flag any such dependency instead of
   adding it.

Every source file carries an SPDX header, for example:

```dart
/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */
```

New hand-written source files must include it — copy the header from a
neighboring file so the wording stays identical. Generated output is exempt and
does not carry it (`.g.dart`, `.freezed.dart`, `lib/generated/`, and
`.dart_tool/` build artifacts).

## Toolchain

The project is a Dart workspace managed by Melos. Flutter SDK: 3.41.2+, Dart
SDK: 3.11.0+. FVM is configured (`.fvmrc`).

## Package Layout

- **`apps/desktop/`** — Main Flutter desktop application entry point
- **`packages/core/`** — Foundation and infrastructure packages (non-feature)
  - `foundation_common` / `foundation_flutter` — ID management, validation, platform utilities
  - `graph_common` / `graph_flutter` — Graph database CRUD and Riverpod providers
  - `stack_common` / `stack_flutter` — Stack lifecycle, metadata, and Riverpod providers
  - `themes`, `settings`, `app_config`, `events`, `exchange`, `localization`, `samples`, `undo`, `workflow`
- **`packages/features/`** — Self-contained feature modules (welcome, pathfinder, record_editor, stack_management, settings, archive, import_export, metadata_editor, updates)
- **`packages/presentation/`** — Shared UI components and workflow widgets
- **`packages/app/`** — App-specific core logic

### Naming Convention

Packages use a `category_name` pattern (e.g., `core_graph_common`,
`features_pathfinder`, `presentation_components`). Pure Dart packages use the
`_common` suffix; Flutter-dependent packages use the `_flutter` suffix.

### Dependency Rules

- Strict downward-only dependencies: `features` → `core` → `foundation`. No
  upward or circular dependencies.
- Core packages must not depend on feature packages.

## Key Architectural Patterns

### State Management (Riverpod)

All state is managed via Riverpod providers. Generated providers use the
`@riverpod` annotation (run `melos run gen:all` after adding or modifying one).
Key provider chain:

```
UI (ConsumerWidget) → Feature Providers → Core Providers → Foundation Providers
```

Critical providers: `activeStackProvider`, `graphContextProvider`,
`availableStacksListProvider`, `activityBarStateProvider`,
`shellStateManagerProvider`.

### Immutable Models (freezed)

Data classes use `@freezed` for immutability and `copyWith`. Run code generation
after modifying any freezed class.

### Stack API Architecture

Three packages collaborate for stack operations — see
[`../stack/stack_api_architecture.md`](../stack/stack_api_architecture.md):

1. **`core_graph_common`** — Graph database lifecycle (`GraphContext`, `ChiffonStorage`)
2. **`core_stack_common`** — Stack directory structure & metadata (`StackService`, `StackMetadataService`)
3. **`core_stack_flutter`** — Riverpod integration (`activeStackProvider`, `StackActions`)

Stack on-disk format:

```
MyProject.stack/
├── meta/info.json      # Stack metadata
├── data/graph.db       # ChiffonDB database file
└── assets/             # Attached files
```

### UI Layout (VS Code-like)

The app shell (`apps/desktop/lib/src/widgets/main_app_shell.dart`) uses a VS
Code-inspired layout: ActivityBar (left) → PrimarySidebar → MainContent →
SecondarySidebar, plus Toolbar (top).

### Performance

Graph views use free-position widgets (via the `plough` package). Avoid
excessive widget rebuilds, especially as node count increases.

## Custom Package Ownership

`ChiffonDB`, `plough`, and `fonde-ui` are authored by the same developer as this
app. Their sources are located at:

- `ChiffonDB`: `../chiffondb/chiffondb/` (Rust core, relative to this repo
  root); Dart bindings in `../chiffondb/chiffondb-dart/`. Referenced via
  `pubspec_overrides.yaml` for local development; the published package is
  `chiffondb` on pub.dev.
- `plough`: locate via `find` or the `llms/` context files

**When a bug or design issue in `ChiffonDB` or `plough` forces an awkward
workaround in app code, fix the library itself rather than patching the app.**
Because the author controls all three codebases, the right fix belongs in the
right place. Do not introduce ad-hoc workarounds in the app when the root cause
is a library API design problem.

## External Package Context

The `llms/` directory stores `llms-full.txt` context files for custom packages
(`kiri_check`, `plough`). These are gitignored — check whether they exist before
working on those packages.
