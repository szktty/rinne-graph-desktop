# AGENTS.md (Project Root)

This document provides a high-level overview and guidelines for AI agents working within the RinneGraph project.

## Project Overview

App is a comprehensive application built with Flutter, leveraging the Melos monorepo management tool. It consists of a primary desktop application, shared packages, documentation, and other supporting modules. The project has undergone significant refactoring to streamline for public release, with much of the older code moved to the `_deprecated` directory.

## Technology Stack

*   **Application Framework**: Flutter (Dart)
*   **Monorepo Management**: Melos
*   **Documentation Website**: Rspress
*   **Scripting**: Shell scripts, Dart utilities

## Key Directories

*   `apps/desktop`: The main and only active application for desktop platforms (macOS, Windows, Linux).
*   `packages/`: Shared Flutter packages, categorized into `core`, `features`, and `presentation`.
*   `docs/`: Official project documentation, including architecture, design, and specifications.
*   `website/`: The project's official website, built with Rspress.

## Getting Started (for development setup)

To set up the project and install dependencies for all packages:

```bash
melos bootstrap
```

To run the desktop application:

```bash
cd apps/desktop
flutter run
```

## Coding Conventions

*   Follow Flutter/Dart official style guides and best practices.
*   Ensure all code is formatted using `dart format .`.
*   Write clear, concise, and self-documenting code.
*   Add comments sparingly, focusing on *why* complex logic exists.

## General Guidance for AI Agents

*   **Current State**: Prioritize information from active directories (`apps/desktop`, `packages`, `docs`, `website`).
*   **Contextual Awareness**: Always refer to the `AGENTS.md` file in the current working directory or its parent directories for specific guidelines.
*   **English First**: All text in source code, comments, and documentation must be written in English.
*   **User Language**: Communicate with the user in the natural language specified by the user.
*   **Convention Adherence**: Strictly follow existing project conventions (naming, formatting, architecture).
*   **Verification**: Always run relevant tests, linters, and type checks after making changes.
*   **Mandatory Build Check**: After any code modification, always perform a build check using `flutter build` to ensure no build errors. `flutter analyze` is for static analysis, not build validation. `flutter run` requires user interaction and is not suitable for automated build checks. If build errors occur, repeatedly attempt to fix them.

## Key Architectural Documents

*   **Stack API Architecture and Usage Guide**: Located at `docs/stack/stack_api_architecture.md`. This document is critical for understanding how the different packages (`core_stack_common`, `core_graph_common`, `core_stack_flutter`) collaborate to manage Stacks, including their metadata and graph database. AI agents should refer to this guide for comprehensive information on Stack-related operations, creation, and persistence.
