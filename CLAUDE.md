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

The project is a Dart workspace managed by Melos. Flutter SDK: 3.38.0+, Dart SDK: 3.7.0+. FVM is configured (`.fvmrc`).

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

## Language

All source code, comments, and documentation must be in English. Communicate with the user in their preferred language.
