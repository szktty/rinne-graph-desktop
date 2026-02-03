# AGENTS.md (llms/)

This document provides guidance for AI agents working within the `llms/` directory.

## Directory Overview

This directory is used to store `llms-full.txt` context files. These files are user-provided to give you deep, package-specific information for development tasks.

**IMPORTANT: Files in this directory are NOT tracked by version control. You MUST NOT commit any `llms-full.txt` files to this repository.**

## Recommended Context Files

The user may place any necessary context files here. The recommended files are for packages purpose-built for App:

*   **RinneGraph (`rinne_graph`)**
*   **kiri-check (`kiri_check`)**
*   **Plough (`plough`)**

If you are asked to work on one of these packages and its context file is not present, you may be instructed to download it from its own repository. To find the repository URL for these packages, you can look them up on pub.dev.

## General Guidance for AI Agents

*   **Check for Context**: Before working on a related package, check if a corresponding `llms-full.txt` file exists in this directory.
*   **Do Not Commit**: Never add, stage, or commit files with the `.txt` extension within this directory.
*   **Security and Privacy**: When handling these files, be cautious not to include sensitive information like API keys.
```