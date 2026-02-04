# Notarization Scripts

This directory contains scripts for automating the macOS application build, notarization, and distribution process.

## Overview

The primary script, `build_and_notarize.sh`, orchestrates the entire release workflow for the RinneGraph desktop application. It performs building, code signing, DMG creation, notarization with Apple, stapling the notarization ticket, and final verification.

## Prerequisites

-   **macOS Environment**: These scripts are designed to run on macOS.
-   **Xcode Command Line Tools**: Ensure Xcode Command Line Tools are installed.
-   **Flutter SDK**: Ensure Flutter SDK is installed and configured.

## Setup

All sensitive information, such as API keys and certificate passwords, is managed through `scripts/notary/env.sh`.

1.  **Create `env.sh`**:
    Copy the template file `env.sh.template` to `env.sh`:
    ```bash
    cp scripts/notary/env.sh.template scripts/notary/env.sh
    ```
    **Important**: `env.sh` is listed in `.gitignore` and must never be committed to the repository.

2.  **Configure `env.sh`**:
    Open `env.sh` and fill in the required values. These include:
    -   `AC_API_KEY_ID`: Your App Store Connect API Key ID.
    -   `AC_API_KEY_ISSUER_ID`: Your App Store Connect API Key Issuer ID.
    -   `AC_API_KEY_PATH`: Path to your `.p8` API Key file.
    -   `CERTIFICATE_P12_PATH`: Path to your Developer ID Application `.p12` file.
    -   `CERTIFICATE_PASSWORD`: The password for your `.p12` file.
    -   `BUNDLE_ID`: The application's bundle identifier.

    Refer to `notary/README.md` in the project root for detailed instructions on obtaining and setting up these credentials.

## Scripts and Usage

### `build_and_notarize.sh`

This script automates the complete macOS application release workflow. It handles:

1.  Flutter application build.
2.  Creation and setup of a temporary keychain.
3.  Code signing of the `.app` bundle with Hardened Runtime.
4.  DMG creation, including a symbolic link to `/Applications`.
5.  Signing of the generated DMG.
6.  Submission of the DMG to Apple's notarization service using `xcrun notarytool` with your App Store Connect API Key.
7.  Stapling the notarization ticket to the DMG.
8.  Final `spctl` and `stapler validate` verification.

-   **Location**: `scripts/notary/build_and_notarize.sh`
-   **Usage**: Run from the project root:
    ```bash
    ./scripts/notary/build_and_notarize.sh
    ```
    The script ensures a clean environment by using a temporary keychain and performing cleanup operations upon completion or interruption.

## Other Files

-   `env.sh.template`: The template for the environment configuration file.
-   `AGENTS.md`: Guidelines for AI agents working in this directory.