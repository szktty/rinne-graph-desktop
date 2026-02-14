Here are the suggested commands for developing in this project:

**Setup & Dependencies:**
- `melos bootstrap`: Install dependencies for all packages.

**Running the Application:**
- `cd apps/desktop && flutter run -d macos`: Run the desktop application on macOS.
- `cd apps/desktop && flutter run -d windows`: Run the desktop application on Windows (experimental).

**Building the Application:**
- `cd apps/desktop && flutter build macos`: Build the macOS application.
- `cd apps/desktop && flutter build windows`: Build the Windows application.
- `./scripts/build.sh`: Build script for macOS (located in the project root).

**Code Generation:**
- `melos run build_runner`: Run build_runner for code generation in packages that use it.
- `melos run gen:all`: Run build_runner in all relevant packages for code generation.

**Testing:**
- `melos run test`: Run tests in all packages.

**Code Quality & Formatting:**
- `melos run analyze`: Run static analysis (linting) across all packages.
- `melos run format`: Format code in all packages.
- `melos run format:check`: Check code formatting in all packages (for CI/pre-commit hooks).
- `melos run fix`: Apply automatic fixes to code issues in all packages.

**Cleaning:**
- `melos run clean`: Clean build cache in all packages.

**Dependency Management:**
- `melos run deps:outdated`: Check for outdated dependencies across all packages.

**General Utilities (Darwin/Unix-like):**
- `git`: Version control commands (e.g., `git status`, `git add`, `git commit`).
- `ls`, `cd`, `grep`, `find`: Standard file system navigation and search utilities.

**Mandatory Build Check after Code Modification:**
- After any code modification, always perform a build check using `flutter build` (e.g., `cd apps/desktop && flutter build macos`) to ensure no build errors. `flutter analyze` is for static analysis, not build validation. `flutter run` requires user interaction and is not suitable for automated build checks.