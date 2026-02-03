# AGENTS.md (apps/)

This document provides guidelines for AI agents working within the `apps/` directory of the RinneGraph project.

## Directory Overview

The `apps/` directory contains the standalone Flutter applications for the RinneGraph project. Currently, the only active application is `desktop`.

## Applications

### `desktop/` - Main Production App
*   **Purpose**: The primary App application for desktop platforms.
*   **Target platforms**: macOS, Windows, Linux
*   **Key Features**: Core application features including graph visualization, data management, and user interface.
*   **Running**:
    ```bash
    cd apps/desktop
    flutter run
    ```
*   **Building**:
    ```bash
    # For a specific platform (e.g., macOS)
    cd apps/desktop
    flutter build macos
    ```

## General Guidance for AI Agents

*   When modifying the application, adhere strictly to its existing architecture, coding style, and framework choices.
*   Before introducing new dependencies, verify their established usage within the project.
*   Ensure changes are tested thoroughly within the context of the `desktop` application.
