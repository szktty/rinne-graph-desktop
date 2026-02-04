# Scripts

This directory contains various shell scripts used for project automation, including versioning, release management, and macOS application notarization.

## Available Scripts

### `generate_version.sh`

This script generates a `version.json` file for the application, embedding detailed build information such as commit hash, build date, and Flutter version. This file is used by the application to display version information in the UI and for bug reports.

-   **Location**: `scripts/generate_version.sh`
-   **Usage**: `./scripts/generate_version.sh`
-   **Output**: `apps/desktop/assets/version.json` (JSON format)

### `new_release_tag.sh`

This script automatically generates a new sequential Git tag based on the current date and the latest existing tag for that day. It ensures that release tags follow a consistent `v0.YYMMDD.Build` format, preventing conflicts and maintaining a clear version history.

-   **Location**: `scripts/new_release_tag.sh`
-   **Usage**: `./scripts/new_release_tag.sh`
-   **Output**: The generated tag name (e.g., `v0.260122.1`) is printed to standard output.

### Notarization Scripts (`notary/`)

This subdirectory contains scripts specifically for automating the macOS application notarization and distribution process.

#### `notary/build_and_notarize.sh`

This is the main script that orchestrates the entire macOS application release process. It handles building the Flutter application, code signing the app bundle, creating and signing a DMG (disk image), submitting the DMG to Apple's notarization service, stapling the notarization ticket, and performing final verification.

-   **Location**: `scripts/notary/build_and_notarize.sh`
-   **Usage**: `./scripts/notary/build_and_notarize.sh` (should be run from the project root)

#### `notary/env.sh.template`

A template file for environment variables required by the `build_and_notarize.sh` script. Users should copy this file to `notary/env.sh` and fill in their sensitive credentials (App Store Connect API Key details, Developer ID certificate password). This file is ignored by Git.

-   **Location**: `scripts/notary/env.sh.template`

#### `notary/README.md`

Documentation providing detailed setup instructions and usage guidelines for the macOS notarization scripts located in the `notary/` subdirectory.

-   **Location**: `scripts/notary/README.md`