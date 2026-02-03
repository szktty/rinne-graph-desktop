# LLM Context Files

This directory is intended to hold `llms-full.txt` context files for LLM-assisted development.

**IMPORTANT: Files in this directory should not be committed to the repository. It is recommended to add `llms/*.txt` to your global `.gitignore` file.**

## Directory Purpose

You can place `llms-full.txt` files from other projects here to provide context to LLM assistants. This allows the AI to understand the code of external packages more deeply.

## Recommended Packages

While any context file can be used, we recommend using `llms-full.txt` for the following core dependencies, which were created specifically for App:

*   **RinneGraph (`rinne_graph`)**
*   **kiri-check (`kiri_check`)**
*   **Plough (`plough`)**

The `llms-full.txt` file for each of these packages can be found in its respective repository. You can download them manually or instruct an AI assistant to do so.

---
*Updated: 2025-12-10*