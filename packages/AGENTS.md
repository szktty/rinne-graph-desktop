# AGENTS.md (packages/)

This document provides guidelines for AI agents working within the `packages/` directory of the RinneGraph project.

## Directory Overview

The `packages/` directory is a core part of the App monorepo, containing reusable Flutter packages. These packages are categorized by their responsibilities and are designed to promote modularity, reusability, and maintainability across different applications.

## Package Categories and Responsibilities

### `core/`
*   **Purpose**: Contains fundamental, low-level utilities, data models, infrastructure components, and shared services that are essential across the entire project. These packages should have minimal dependencies on other App packages, primarily depending on Flutter SDK and well-established third-party libraries.
*   **Examples**: Graph data structures, common utilities, platform abstractions.

### `features/`
*   **Purpose**: Encapsulates specific, self-contained features that can be integrated into one or more applications. A feature package typically includes its own UI components, business logic, and data handling related to that specific feature.
*   **Examples**: Home screen feature, settings feature, authentication feature.

### `presentation/`
*   **Purpose**: Houses shared UI components, design systems, themes, and presentation logic that are common across applications but are not tied to a specific feature. These packages focus purely on the visual layer.
*   **Examples**: Custom widgets, design tokens, theming utilities, localization resources.

### `app/`
*   **Purpose**: (If applicable) Packages that represent a specific application's core logic or unique components that are not generic enough to be in `features` or `presentation`, but are separated for better modularity than being directly in `apps/`.
*   **Example**: `packages/app/` might contain app-specific business logic.

## Dependency Rules

*   **Upward Dependencies Only**: Packages should generally only depend on packages within `core/` or other `features/` packages if a clear, unidirectional flow is maintained (e.g., a feature might depend on a core utility, but a core utility should not depend on a feature).
*   **Avoid Circular Dependencies**: Circular dependencies between packages are strictly forbidden.
*   **Minimize Dependencies**: Aim to keep package dependencies to a minimum to ensure high cohesion and loose coupling.

## Creating New Packages

When creating a new package, follow existing project conventions for consistent setup.
1.  Place the package in the appropriate category (`core/`, `features/`, `presentation/`, etc.) based on its primary responsibility.
2.  Define clear `pubspec.yaml` dependencies.
3.  Ensure it includes its own `README.md` and `analysis_options.yaml`.

## General Guidance for AI Agents

*   Before creating a new package, search for existing packages that might already provide the necessary functionality.
*   When modifying a package, consider its impact on all dependent applications and packages.
*   Adhere to the package's defined scope and avoid scope creep.
*   Ensure all new or modified packages include comprehensive tests.
*   **Performance Considerations for UI**: When implementing UI, especially graph views where nodes are free-position widgets (e.g., in `plough`), be highly mindful of performance. Avoid excessive widget rebuilds, particularly as the number of nodes increases, to ensure a smooth user experience.
