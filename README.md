# RinneGraph

[日本語](README.ja.md)

[![CLA assistant](https://cla-assistant.io/readme/badge/szktty/rinne-graph-desktop)](https://cla-assistant.io/szktty/rinne-graph-desktop)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.2-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-lightgrey)](README.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

![RinneGraph Screenshot](docs/images/screenshot.png)

**⚠️ WORK IN PROGRESS - ALPHA STAGE ⚠️**

## 🚧 Project Status

**This project is in Alpha stage.**

- ❌ **Not ready for production use**
- ❌ **Features are incomplete and may not work as expected**
- ❌ **Breaking changes may occur frequently**
- ✅ **Feedback and bug reports are welcome**

## What is RinneGraph?

RinneGraph is an app for connecting ideas and shaping your world. It focuses on visualizing the connections between data, and by looking at the graph of connections from a bird's-eye view, a new map of ideas emerges.

## 💡 Features

- **Local-first & offline** — works entirely on your device, no graph database server required
- **Property graph** — data is structured as nodes and links
- **Graph view** — visualize connections between nodes
- **Graph search** — traverse and search through connections

## 🚀 Quick Start

Download the latest release for your platform from the [Releases page](https://github.com/szktty/rinne-graph-desktop/releases).

### Supported Platforms

- ✅ **macOS** (Primary support)
- ✅ **Windows** (Experimental support)

**Note**: Windows support is experimental. The application should build and run, but some features may not work as expected. Feedback is welcome!

## 🔨 Building from Source

### Prerequisites

- Flutter 3.41.2 or higher
- Dart 3.11.0 or higher
- Melos (monorepo management tool)

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
```


## 🔗 Related Projects

The following libraries were developed primarily for RinneGraph and are maintained alongside it:

- **[ChiffonDB](https://github.com/szktty/chiffondb)** — Embedded property-graph database written in Rust ([`chiffondb`](https://pub.dev/packages/chiffondb) Dart bindings)
- **[Fonde UI](https://github.com/szktty/fonde-ui)** — Desktop-first UI components
- **[plough](https://github.com/szktty/plough)** — Network graph rendering library for Flutter
- **[kiri_check](https://github.com/szktty/kiri_check)** — Property-based testing library for Dart

## 🐛 Reporting Issues

If you encounter bugs or have suggestions, please open an issue. Note that response time may vary.

- Check existing [Issues](https://github.com/szktty/rinne-graph-desktop/issues) first to avoid duplicates.
- For bug reports, include:
    - Steps to reproduce
    - Expected vs actual behavior
    - System information:
        - RinneGraph version
        - OS version
        - Flutter version (if built from source)

## 📄 License

This project is dual-licensed:

- **[GNU Affero General Public License v3.0 (AGPLv3)](LICENSE)** — for open-source use
- **Commercial License** — for organizations or individuals who need to use RinneGraph without the AGPLv3 obligations (available in the future)

### Contributing & CLA

Contributions are welcome! By submitting a Pull Request, you agree to the [Contributor License Agreement (CLA)](https://gist.github.com/szktty/098a5717a813146dd797e557400a31c1). See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Commercial License

A **commercial license** will be available in the future for organizations or individuals who need to use RinneGraph without the obligations of the AGPLv3 (e.g., source disclosure requirements for network-deployed services, internal enterprise use).

If you are interested in a future commercial license or have any licensing inquiries, please contact:

**contact@szktty.jp**

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

## 💖 Sponsorship

RinneGraph is a personal project. If it interests you, your support via [GitHub Sponsors](https://github.com/sponsors/szktty) would be greatly appreciated and is a huge encouragement to keep development going.
