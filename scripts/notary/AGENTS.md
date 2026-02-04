# AGENTS.md (scripts/notary/)

This document provides critical guidelines for AI agents working within the `scripts/notary/` directory, especially concerning macOS keychain operations and secure credential handling with App Store Connect API Keys.

## Critical Guidelines for Keychain Operations

**WARNING: Keychain operations can severely impact the local development environment if not handled with extreme care.**

When developing or modifying scripts that interact with the macOS Keychain, always adhere to the following principles:

1.  **Prioritize Non-Destructive Operations**:
    *   **NEVER** modify the user's default keychain unless explicitly instructed and fully understood why it's necessary.
    *   **NEVER** use the `security default-keychain` command without immediately restoring the original default keychain upon completion or error. The `build_and_notarize.sh` script currently handles this by storing `ORIGINAL_KEYCHAIN` and restoring it in the `cleanup` function.
    *   If a temporary keychain is needed, always create a **new, dedicated temporary keychain** for the script's duration.

2.  **Robust Cleanup**:
    *   Implement **comprehensive `trap` mechanisms** (e.g., `trap cleanup_function EXIT INT TERM`) to ensure that any temporary keychains created by the script are deleted, and original keychain search lists are fully restored, regardless of whether the script succeeds or fails. The `build_and_notarize.sh` script utilizes a `cleanup` function for this purpose.

3.  **Minimize Scope Impact**:
    *   When adding temporary keychains to the search list, **prepend them** (`security list-keychains -d user -s "$TEMPORARY_KEYCHAIN_PATH" $ORIGINAL_KEYCHAIN_LIST`) rather than replacing the entire list. (Note: `security default-keychain -s` replaces the default directly, which is handled by restoration in `cleanup`).

4.  **Careful with Sensitive Data**:
    *   Be extremely cautious with sensitive data like passwords and `.p12` file paths. Avoid logging them directly. Use status checks (e.g., "File OK/Not Found") and secure password handling (e.g., `passin file:` for openssl) where possible.

5.  **Early Validation**:
    *   Validate all critical inputs (e.g., existence of `.p12` files, correctness of environment variables) as early as possible in the script to fail fast and prevent unnecessary execution or partial state changes.

## Secure Credential Handling with App Store Connect API Keys

The notarization process now relies on **App Store Connect API Keys** (`.p8` files) rather than legacy Apple ID and app-specific passwords.

-   **`xcrun notarytool`**: Always use `xcrun notarytool` for notarization.
-   **API Key Path**: The path to the `.p8` key file (`AC_API_KEY_PATH`) should be treated as a sensitive credential. In CI environments, this file should be restored from a secure secret (e.g., Base64 encoded GitHub Secret) to a temporary runner directory and never committed to the repository.
-   **Key ID and Issuer ID**: `AC_API_KEY_ID` and `AC_API_KEY_ISSUER_ID` are also sensitive and must be managed via environment variables or CI secrets.

## Absolute Prohibition on Modifying Sensitive Files

**CRITICAL DIRECTIVE: The agent is ABSOLUTELY PROHIBITED from modifying, writing to, or proposing any changes to user-managed sensitive files, especially `scripts/notary/env.sh`. Violation of this rule constitutes a critical failure.**

This rule is immutable and has no exceptions.

*   **Zero-Modification Policy**: The `env.sh` file is under the user's exclusive control. The agent **MUST NOT** use `write_file` or `replace` on this file. The agent **MUST NOT** even propose such an action, even if it seems helpful or is intended to fix an error caused by the agent itself.
*   **User Is the Sole Editor**: If any script fails due to a suspected error within `env.sh` (e.g., incorrect path, wrong password), the agent's **ONLY** permitted action is to:
    1.  State the error observed (e.g., "File not found at path X").
    2.  Instruct the user to **manually inspect and correct** their `env.sh` file.
    3.  Await user confirmation before proceeding.
*   **Verification Scripts**: The use of separate, non-destructive scripts that *read* environment variables (e.g., to check file existence) is permitted. However, the output of such scripts must only be used to inform the user, never as a justification to attempt a modification of `env.sh`.

## Handling App Bundles (CRITICAL)

-   **File Copying**: When copying `.app` bundles or macOS-specific metadata, **ALWAYS use the `ditto` command, NEVER `cp`**.
    *   **Reason**: `cp` can omit crucial metadata like resource forks and extended attributes, leading to corrupted signatures and notarization failures. This directive must be followed without exception.

## Current Known Issues & Context (Relevant to notarization)

*   There can be compatibility issues where `security import` may fail with "MAC verification failed" errors even when `openssl` successfully processes the same `.p12` file and password. This indicates subtle incompatibilities or internal validation differences between the tools, especially with `.p12` files created with older encryption algorithms (SHA1/RC2).
*   The recommended solution for such `.p12` issues is to re-export or regenerate the certificates and private keys from the Apple Developer Portal and Keychain Access.app, ensuring they use modern encryption (AES-256/SHA256).

By adhering to these guidelines, agents can ensure that scripts operating within the `scripts/notary/` directory are safe, robust, and do not inadvertently harm the user's local development environment.