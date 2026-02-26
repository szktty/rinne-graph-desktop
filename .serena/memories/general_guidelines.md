**General Guidance for AI Agents:**
- Prioritize information from active directories (`apps/desktop`, `packages`, `docs`, `website`).
- Contextual Awareness: Always refer to the `AGENTS.md` or `CLAUDE.md` file in the current working directory or its parent directories for specific guidelines.
- English First: All text in source code, comments, and documentation must be written in English.
- User Language: Communicate with the user in the natural language specified by the user.
- Convention Adherence: Strictly follow existing project conventions (naming, formatting, architecture).
- Verification: Always run relevant tests, linters, and type checks after making changes.
- Mandatory Build Check: After any code modification, always perform a build check using `flutter build` to ensure no build errors. `flutter analyze` is for static analysis, not build validation. `flutter run` requires user interaction and is not suitable for automated build checks. If build errors occur, repeatedly attempt to fix them.
- One File at a Time: Edit a single file, then run `flutter build macos` to verify. Do NOT batch-edit multiple files before building.
- freezed 3.x / riverpod 3.x: The project has migrated to major versions. Code generation patterns may differ from older versions. Always run `melos run gen:all` after modifying annotated code.

**Key Architectural Documents:**
- `docs/stack/stack_api_architecture.md`: Critical for understanding how the different packages (`core_stack_common`, `core_graph_common`, `core_stack_flutter`) collaborate to manage Stacks, including their metadata and graph database. AI agents should refer to this guide for comprehensive information on Stack-related operations, creation, and persistence.
