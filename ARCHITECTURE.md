# Architecture Overview

This document provides an overview of the RinneGraph architecture. It is intended to help developers quickly understand the codebase and develop efficiently.

**Last Updated**: 2026-02-04

## 1. Project Overview

RinneGraph is a "graph-based personal database for organically managing and organizing individual knowledge and data."

### Core Concepts

- **Robustness as a Database**: Reliability based on SQLite.
- **Usability as an Information Organizer**: Intuitive and user-friendly UI.
- **Graph Structure**: Natural representation of relationships through nodes and links.

### Target Platforms

| Platform | Status |
|---|---|
| macOS | ✅ Primary Support |
| Windows | 🧪 Experimental Support |
| Linux | 🧪 Experimental Support |
| iOS/Android | 📋 Planned for Future |

## 2. Project Structure

The project follows a monorepo structure managed by Melos.

```
rinne-graph-desktop/
├── apps/
│   └── desktop/                 # The main and only active application
├── packages/
│   ├── app/                     # App-specific logic and components
│   ├── core/                    # Core packages (non-UI)
│   │   ├── app_config/          # Application configuration
│   │   ├── events/              # Event handling system
│   │   ├── exchange/            # Data import/export format
│   │   ├── foundation_common/   # Foundational utilities (common)
│   │   ├── foundation_flutter/  # Foundational utilities (Flutter-specific)
│   │   ├── graph_common/        # Graph database APIs (common)
│   │   ├── graph_flutter/       # Graph database APIs (Flutter-specific)
│   │   ├── localization/        # Localization and internationalization
│   │   ├── samples/             # Sample data
│   │   ├── settings/            # Settings management
│   │   ├── stack_common/        # Stack management (common)
│   │   ├── stack_flutter/       # Stack management (Flutter-specific)
│   │   ├── themes/              # Theme and color system
│   │   ├── undo/                # Undo/Redo framework
│   │   └── workflow/            # Workflow and command management
│   ├── features/                # Feature packages (self-contained modules)
│   │   ├── import_export/       # Import/Export UI
│   │   ├── metadata_editor/     # Metadata editor UI
│   │   ├── pathfinder/          # Search and navigation
│   │   ├── record_editor/       # Node/Link editor UI
│   │   ├── settings/            # Settings UI
│   │   ├── stack_management/    # Stack management UI
│   │   ├── updates/             # App update notifications
│   │   └── welcome/             # Welcome screen
│   └── presentation/            # Shared UI components
│       ├── components/          # Foundational UI widgets
│       └── workflow/            # Workflow-related UI components
├── docs/                        # Project documentation
└── .github/                     # CI/CD workflows
```

## 3. High-Level System Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        Desktop App (Flutter)                     │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Presentation Layer                        ││
│  │  ┌─────────────┐ ┌─────────────┐                            ││
│  │  │ components  │ │  workflow   │                            ││
│  │  └─────────────┘ └─────────────┘                            ││
│  └─────────────────────────────────────────────────────────────┘│
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                     Features Layer                           ││
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            ││
│  │  │record_editor│ │ pathfinder  │ │  settings   │ ...        ││
│  │  └─────────────┘ └─────────────┘ └─────────────┘            ││
│  └─────────────────────────────────────────────────────────────┘│
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                       Core Layer                             ││
│  │  ┌────────────┐ ┌──────────┐ ┌────────┐ ┌──────────┐        ││
│  │  │graph_common│ │stack_common│ │ themes │ │ settings │ ...    ││
│  │  └────────────┘ └──────────┘ └────────┘ └──────────┘        ││
│  │  ┌───────────────────────────────────────────────┐          ││
│  │  │            foundation (common/flutter)        │          ││
│  │  └───────────────────────────────────────────────┘          ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RinneGraph (SQLite Database)                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                   Property Graph Model                     │  │
│  │         Nodes ◄────── Links ──────► Nodes                 │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## 4. Core Components

### 4.1. Frontend (Desktop App)

| Item | Details |
|---|---|
| **Description** | The main user interface of the application. |
| **Technology** | Flutter 3.38.2, Dart 3.7+ |
| **State Management** | Riverpod |
| **Deployment** | macOS App Bundle, Windows Executable, Linux Executable |

### 4.2. Core Packages

#### core_graph (common/flutter)
- **Purpose**: Provides fundamental functionalities for the graph database.
- **Key Classes**: `Entity`, `Node`, `Link`, `GraphContext`, `GraphQuery`
- **Providers**: `graphContextProvider`, `nodeOperationsProvider`, `linkOperationsProvider`

#### core_stack (common/flutter)
- **Purpose**: Manages user databases, known as "stacks".
- **Key Features**: Create, open, and delete stacks; manage stack metadata.
- **Providers**: `availableStacksListProvider`, `stackActionsProvider`

#### core_themes
- **Purpose**: Manages themes and color schemes.
- **Key Features**: Light/dark mode, custom themes, accessibility settings.
- **Providers**: `effectiveColorSchemeProvider`, `accessibilityConfigProvider`

#### core_foundation (common/flutter)
- **Purpose**: Provides foundational utilities and common functionalities.
- **Key Features**: ID generation, file system operations, platform information.

## 5. Data Store

### 5.1. RinneGraph (Graph Database)

| Item | Details |
|---|---|
| **Type** | Embedded graph database built on SQLite. |
| **Purpose** | Persistence of nodes, links, and their properties. |
| **Model** | Extended Property Graph Model. |
| **Key Tables** | `nodes`, `links`, `properties`, `labels`. |

### 5.2. Stack Structure

A stack is a self-contained directory that stores user data.

```
MyProject.stack/
├── meta/
│   └── info.json           # Stack metadata
├── data/
│   └── graph.db            # RinneGraph SQLite file
└── assets/                 # Attached files
```

### 5.3. Application Settings

| Platform | Path | Purpose |
|---|---|---|
| macOS | `~/Library/Application Support/App/` | App settings, cache |
| Linux | `~/.config/App/` | App settings, cache |
| Windows | `%APPDATA%\App\` | App settings, cache |
| All | User's `Documents/App/` directory | Default location for user stacks |


## 6. State Management Architecture

### Riverpod Provider Hierarchy

The app uses Riverpod for state management, with a layered provider architecture.

```
┌─────────────────────────────────────────┐
│           UI Widgets (Consumer)         │
│       ref.watch() / ref.read()          │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│         Feature Providers               │
│  (e.g., pathfinderActionsProvider)      │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│           Core Providers                │
│  (e.g., graphContextProvider)           │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│      Foundation Providers               │
│  (e.g., fileSystemServiceProvider)      │
└─────────────────────────────────────────┘
```

## 7. UI Design

### Layout Structure (VS Code-like)

The main application window adopts a layout similar to Visual Studio Code.

```
┌─────────────────────────────────────────────────────────────────┐
│                        Title Bar                                 │
├─────┬───────────────────────────────────────────────────────────┤
│     │                      Toolbar                               │
│ A   ├─────────────────────────────────────────────┬─────────────┤
│ c   │                                             │             │
│ t   │                                             │   Right     │
│ i   │    Sidebar (Left)     Main Content Area     │   Sidebar   │
│ v   │                                             │ (Optional)  │
│ i   │                                             │             │
│ t   │                                             │             │
│ y   │                                             │             │
│     │                                             │             │
│ B   │                                             │             │
│ a   │                                             │             │
│ r   │                                             │             │
└─────┴─────────────────────────────────────────────┴─────────────┘
```

## 8. Package Dependency Rules

### Layer Dependency Rules

Dependencies must flow downwards. A layer can only depend on layers below it.

```
Presentation Layer ──► Features Layer ──► Core Layer ──► Foundation
```

| Layer | Can Depend On | Cannot Depend On |
|---|---|---|
| Presentation | Core, Features, Foundation | - |
| Features | Core, Foundation | (Other Features), Presentation |
| Core | Foundation | Features, Presentation |
| Foundation | External Packages Only | Any internal package |

### Package Naming Conventions

- `core_*`: Core logic packages (e.g., `core_graph_common`).
- `features_*`: Self-contained feature packages (e.g., `features_pathfinder`).
- `presentation_*`: Shared UI component packages (e.g., `presentation_components`).

## 9. Development Environment & Tools

### Required Tools

| Tool | Version | Purpose |
|---|---|---|
| Flutter | 3.38.2 | UI Framework |
| Dart | 3.7.0+ | Programming Language |
| Melos | Latest | Monorepo Management |

### Key Commands

```bash
# Bootstrap the project and install dependencies
melos bootstrap

# Run the desktop application
cd apps/desktop
flutter run -d macos

# Build the application
flutter build macos

# Run all tests in the workspace
melos run test

# Run code generation (build_runner)
melos run gen:build

# Run static analysis
flutter analyze
```

## 10. Related Documents

| Document | Path |
|---|---|
| Project AGENTS.md | `AGENTS.md` |
| Apps AGENTS.md | `apps/AGENTS.md` |
| Packages AGENTS.md | `packages/AGENTS.md` |
| Desktop App Readme | `apps/desktop/README.md` |