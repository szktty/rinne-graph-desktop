The project is a Flutter monorepo managed by Melos.

**Key Directories:**
- `apps/desktop`: The main desktop application targeting macOS and Windows (Linux experimental).
- `packages/`: Contains shared Flutter packages, categorized as:
    - `core/`: Fundamental, low-level utilities, data models, infrastructure components, and shared services.
      Packages: `app_config`, `events`, `exchange`, `foundation_common`, `foundation_flutter`,
      `graph_common`, `graph_flutter`, `localization`, `samples`, `settings`,
      `stack_common`, `stack_flutter`, `themes`, `undo`, `workflow`.
    - `features/`: Self-contained features with UI components, business logic, and data handling.
      Packages: `archive`, `charts`, `import_export`, `metadata_editor`, `pathfinder`,
      `record_editor`, `settings`, `stack_management`, `updates`, `welcome`.
    - `presentation/`: Shared UI components, design systems, themes, and presentation logic.
      Packages: `components`, `workflow`.
    - `app/`: App-specific core logic.
- `docs/`: Official project documentation, including architecture, design, and specifications.
- `website/`: The project's official website, built with Rspress.
- `scripts/`: Contains various utility scripts (e.g., `build.sh`, `notary/`).
- `llms/`: Contains LLM-specific context files (not version controlled).

**Package Naming Convention:**
Packages use a `category_name` pattern (e.g., `core_graph_common`, `features_pathfinder`, `presentation_components`).
Pure Dart packages use `_common` suffix; Flutter-dependent packages use `_flutter` suffix.

**Dependency Rules:**
- Strict downward-only dependencies: `features` → `core` → `foundation`. No upward or circular dependencies.
- Core packages must not depend on feature packages.
- Avoid Circular Dependencies.
- Minimize Dependencies.

**Stack On-Disk Format:**
```
MyProject.stack/
├── meta/info.json      # Stack metadata
├── data/graph.db       # ChiffonDB database file
└── assets/             # Attached files
```
