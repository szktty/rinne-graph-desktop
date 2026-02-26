# RinneGraph

**⚠️ WORK IN PROGRESS - ALPHA STAGE ⚠️**

RinneGraph is a graph-based personal knowledge management application. It helps users manage and organize their personal knowledge using a property graph database approach, allowing for intuitive visualization and navigation of interconnected information.

## 🚧 Project Status

**This project is in early Alpha stage and under active development.**

- ❌ **Not ready for production use**
- ❌ **Features are incomplete and may not work as expected**
- ❌ **Breaking changes may occur frequently**
- ✅ **Feedback and bug reports are welcome**

**Current Focus**: Building MVP (Minimum Viable Product) for early feedback collection.

## 📋 What is App?

App is a personal database organizer that uses a graph database structure to help users manage and organize their personal knowledge. It allows users to visualize relationships between different pieces of information and search and navigate through their data efficiently.

## 💡 Features

- Organize personal data using a graph database structure (nodes and links)
- Visualize relationships between different pieces of information
- Search and navigate through your data efficiently
- Manage data in self-contained "stacks" (portable database units)

## 🚀 Quick Start

### Prerequisites

- Flutter 3.41.2 or higher
- Dart 3.11.0 or higher
- Melos (monorepo management tool)

### Supported Platforms

- ✅ **macOS** (Primary support)
- ✅ **Windows** (Experimental support)

**Note**: Windows support is experimental. The application should build and run, but some features may not work as expected. Feedback is welcome!

### Setup

```bash
# Clone the repository
git clone https://github.com/szktty/rinne_graph_desktop.git
cd rinne_graph_desktop

# Install dependencies (using Melos for monorepo management)
flutter pub get
melos bootstrap

# Run the desktop app
cd apps/desktop
flutter run -d macos  # or -d windows
```

### Build

```bash
# macOS
cd apps/desktop
flutter build macos

# Windows
cd apps/desktop
flutter build windows

# Or use the build script (macOS only)
./scripts/build.sh
```


## 📚 Documentation

- [Development Strategy](docs/strategy/governance/DEVELOPMENT_STRATEGY.md) - Project development approach and release cycle
- [Publishing Checklist](docs/strategy/governance/PUBLISHING_CHECKLIST.md) - MVP release preparation tasks

## 🐛 Reporting Issues

This project is in early development. If you encounter bugs or have suggestions:

1.  Check existing [Issues](https://github.com/szktty/rinne_graph_desktop/issues) to avoid duplicates (Replace with actual public URL)
2.  Create a new issue with detailed information:
    *   Steps to reproduce
    *   Expected vs actual behavior
    *   Your environment (OS, Flutter version, etc.)

**Note**: Response time may vary as this is a personal project under active development.

## 📄 License

This project is licensed under the AGPLv3. See the [LICENSE](LICENSE) file for details.

## Versioning

This project uses a hybrid versioning strategy, separating the user-facing **Display Version** from the tool-facing **Technical Version**. Version generation is automated through Melos scripts.

### Technical Version (`pubspec.yaml`)

For compatibility with the Dart package manager (`pub`), the version in `pubspec.yaml` adheres to the Semantic Versioning (SemVer) format `MAJOR.MINOR.PATCH+BUILD_METADATA`.

- **Format:** `0.YYMMDD.Build+CommitHash`
- **Example:** `0.251013.1+a1b2c3d`

**Components:**
- **`0.`**: The major version is fixed at `0` to indicate that the project is not yet stable (pre-1.0.0).
- **`YYMMDD`**: The minor version is the date of the build in `YYMMDD` format.
- **`Build`**: The patch version is an incrementing number for builds made on the same day.
- **`+CommitHash`**: The build metadata contains the short Git commit hash, allowing any build to be traced back to its exact source code. This part is ignored by SemVer for precedence comparison.

### Display Version (UI & Logs)

Human-readable version string shown in the app's "About" screen.

-   **Format:** `[Stage] Build YY.MM.DD.Build (CommitHash)`
-   **Example:** `Alpha Build 25.10.13.1 (a1b2c3d)`

This dual approach ensures the project's versioning is both tool-compatible and human-friendly, providing clarity and traceability.