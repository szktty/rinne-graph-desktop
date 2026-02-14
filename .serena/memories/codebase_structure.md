The project is a Flutter monorepo managed by Melos.

**Key Directories:**
- `apps/desktop`: The main desktop application targeting macOS, Windows, and Linux.
- `packages/`: Contains shared Flutter packages, categorized as:
    - `core/`: Fundamental, low-level utilities, data models, infrastructure components, and shared services (e.g., `events`, `exchange`, `foundation_flutter`, `graph_common`, `localization`, `stack_flutter`, `themes`, `undo`, `workflow`).
    - `features/`: Self-contained features with UI components, business logic, and data handling (e.g., `archive`, `import_export`, `metadata_editor`, `pathfinder`, `record_editor`, `settings`, `stack_management`, `updates`, `welcome`).
    - `presentation/`: Shared UI components, design systems, themes, and presentation logic (e.g., `components`, `workflow`).
- `docs/`: Official project documentation, including architecture, design, and specifications.
- `website/`: The project's official website, built with Rspress.
- `scripts/`: Contains various utility scripts (e.g., `build.sh`, `notary/`).
- `llms/`: Contains LLM-specific context files (not version controlled).

**Dependency Rules:**
- Upward Dependencies Only: Packages should generally only depend on packages within `core/` or other `features/` packages if a clear, unidirectional flow is maintained.
- Avoid Circular Dependencies.
- Minimize Dependencies.