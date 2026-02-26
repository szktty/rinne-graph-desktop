# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RinneGraph is a graph-based personal knowledge management desktop app (alpha stage). Built with Flutter/Dart, it uses a property graph database to let users organize knowledge as interconnected nodes and links within portable "stacks."

- **Platforms**: macOS (primary), Windows (experimental)
- **License**: AGPLv3

## Build & Development Commands

```bash
# Setup
flutter pub get
melos bootstrap

# Run the app
cd apps/desktop && flutter run -d macos    # or -d windows

# Build (mandatory after code changes to verify no build errors)
cd apps/desktop && flutter build macos

# Run all tests
melos run test

# Run tests in a single package
cd packages/core/foundation_common && flutter test
# Run a single test file
cd packages/core/foundation_common && flutter test test/some_test.dart

# Code generation (Riverpod providers, freezed models, JSON serialization)
melos run gen:all

# Static analysis
melos run analyze

# Format code
melos run format

# Apply automatic fixes
melos run fix
```

**Important**: After any code modification, always run `flutter build macos` (from `apps/desktop/`) to verify no build errors. `flutter analyze` is for static analysis only, not build validation.

## Monorepo Architecture (Melos)

The project is a Dart workspace managed by Melos. Flutter SDK: 3.41.2+, Dart SDK: 3.11.0+. FVM is configured (`.fvmrc`).

### Package Layout

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

Packages use a `category_name` pattern (e.g., `core_graph_common`, `features_pathfinder`, `presentation_components`). Pure Dart packages use `_common` suffix; Flutter-dependent packages use `_flutter` suffix.

### Dependency Rules

- Strict downward-only dependencies: `features` → `core` → `foundation`. No upward or circular dependencies.
- Core packages must not depend on feature packages.

## Key Architectural Patterns

### State Management (Riverpod)

All state is managed via Riverpod providers. Generated providers use `@riverpod` annotation (run `melos run gen:all` after adding/modifying). Key provider chain:

```
UI (ConsumerWidget) → Feature Providers → Core Providers → Foundation Providers
```

Critical providers: `activeStackProvider`, `graphContextProvider`, `availableStacksListProvider`, `activityBarStateProvider`, `shellStateManagerProvider`.

### Immutable Models (freezed)

Data classes use `@freezed` for immutability and `copyWith`. Run code generation after modifying any freezed class.

### Stack API Architecture

Three packages collaborate for stack operations — see `docs/stack/stack_api_architecture.md`:
1. **`core_graph_common`** — Graph database lifecycle (`GraphContext`, `RinneGraphStorage`)
2. **`core_stack_common`** — Stack directory structure & metadata (`StackService`, `StackMetadataService`)
3. **`core_stack_flutter`** — Riverpod integration (`activeStackProvider`, `StackActions`)

Stack on-disk format:
```
MyProject.stack/
├── meta/info.json      # Stack metadata
├── data/graph.db       # SQLite RinneGraph database
└── assets/             # Attached files
```

### UI Layout (VS Code-like)

The app shell (`apps/desktop/lib/src/widgets/main_app_shell.dart`) uses a VS Code-inspired layout: ActivityBar (left) → PrimarySidebar → MainContent → SecondarySidebar, plus Toolbar (top).

### Performance

Graph views use free-position widgets (via `plough` package). Avoid excessive widget rebuilds, especially as node count increases.

## External Package Context

The `llms/` directory stores `llms-full.txt` context files for custom packages (`rinne_graph`, `kiri_check`, `plough`). These are gitignored — check if they exist before working on those packages.

## Work Rules

### Editing Discipline

- **One file at a time**: Edit a single file, then run `flutter build macos` (from `apps/desktop/`) to verify. Do NOT batch-edit multiple files before building. This prevents cascading failures that are hard to trace back.
- **Read the full file before editing**: Always use the Read tool to view the complete file before making changes. For files over 500 lines, read the entire file — do not rely on partial context or memory of the file's structure.
- **When an Edit fails**: Do not retry with a guess. Re-read the file to get the current state, then construct the correct edit.

### Error Handling

- **Root cause first**: When a build error or runtime issue occurs, do NOT immediately patch the symptom. Instead:
  1. Read the full error message and identify which file/line is the actual source.
  2. Trace the data flow upstream to find the root cause (often in a different package).
  3. Fix the root cause, then verify downstream effects.
- **Stop after 2 failed attempts**: If the same error persists after two fix attempts, pause and explain the situation to the user rather than continuing to iterate. The fix approach is likely wrong.

### Impact Analysis Before Changes

- **Check dependents**: Before modifying any file in `packages/core/`, check what depends on the changed API by searching for imports and usages across the monorepo. A change in a core package can break multiple feature packages.
- **Provider chain awareness**: When modifying a Riverpod provider, trace both directions — what it watches (upstream) and what watches it (downstream). Changes to a provider's return type or behavior ripple through all consumers.

### Required Reading Before Tasks

Read the relevant documentation BEFORE starting implementation:

- **Cross-package data flows**: `docs/architecture/data_flows.md` (read first for any multi-package change)
- **Known complexity hotspots**: `docs/architecture/data_flow_concerns.md`
- **Stack operations** (create, load, save, delete): `docs/stack/stack_api_architecture.md`
- **Import/export**: `docs/stack/stack_exchange_format_specification.md`
- **UI component changes**: `docs/design/03-components.md` and `docs/design/04-implementation.md`
- **Color/theme changes**: `docs/design/02-design-tokens.md` and `docs/design/09-color-design-guidelines.md`
- **Dialog/panel layout**: `docs/design/13-panel-layout-guidelines.md` and `docs/design/15-warning-error-dialog-guidelines.md`
- **Custom libraries** (rinne_graph, plough, kiri_check): Check `llms/` for context files first

### Planning for Complex Changes

For tasks that touch 3+ files or cross package boundaries, use plan mode:
1. List all files that will be modified and why.
2. Identify the data flow path (which providers/services are involved).
3. Define the order of changes (start from the lowest-level package, work upward).
4. Get user approval before starting implementation.

### Progress Logging

Before interrupting or ending work, always record the current state in a progress log file. This facilitates handoff between sessions. The log must include:

1. **Current state**: What has been completed so far.
2. **Remaining tasks**: What still needs to be done.
3. **Failed approaches**: Approaches that were attempted but did not work, and why.

Log file requirements:
- Written in Markdown.
- Saved under the `docs/progress/` directory.
- File name must include the name of the task being worked on (e.g., `docs/progress/add-dark-mode.md`).

## Language

All source code, comments, and documentation must be in English. Communicate with the user in their preferred language.
