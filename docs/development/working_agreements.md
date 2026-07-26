# Working Agreements

Detailed rules for how changes are made in this repository. `CLAUDE.md` carries
the short version; this file is the full text.

## Commands

```bash
# Setup
flutter pub get
melos bootstrap

# Run the app
cd apps/desktop && flutter run -d macos    # or -d windows

# Build (mandatory after code changes to verify no build errors)
cd apps/desktop && flutter build macos

# Run all tests
melos run test

# Run tests in a single package
cd packages/core/foundation_common && flutter test
# Run a single test file
cd packages/core/foundation_common && flutter test test/some_test.dart

# Code generation (Riverpod providers, freezed models, JSON serialization)
melos run gen:all

# Static analysis
melos run analyze

# Format code
melos run format

# Apply automatic fixes
melos run fix
```

`flutter analyze` is for static analysis only, not build validation. Only
`flutter build macos` confirms the code builds.

Generated files (`.g.dart`, `.freezed.dart`) are never edited by hand — change
the source and re-run `melos run gen:all`.

## Editing Discipline

- **One file at a time**: Edit a single file, then run `flutter build macos`
  (from `apps/desktop/`) to verify. Do NOT batch-edit multiple files before
  building. This prevents cascading failures that are hard to trace back.
- **Read the full file before editing**: Always use the Read tool to view the
  complete file before making changes. For files over 500 lines, read the entire
  file — do not rely on partial context or memory of the file's structure.
- **When an edit fails**: Do not retry with a guess. Re-read the file to get the
  current state, then construct the correct edit.

## Error Handling

- **Root cause first**: When a build error or runtime issue occurs, do NOT
  immediately patch the symptom. Instead:
  1. Read the full error message and identify which file/line is the actual
     source.
  2. Trace the data flow upstream to find the root cause (often in a different
     package).
  3. Fix the root cause, then verify downstream effects.
- **Stop after 2 failed attempts**: If the same error persists after two fix
  attempts, pause and explain the situation to the user rather than continuing
  to iterate. The fix approach is likely wrong.

## Impact Analysis Before Changes

- **Check dependents**: Before modifying any file in `packages/core/`, check
  what depends on the changed API by searching for imports and usages across the
  monorepo. A change in a core package can break multiple feature packages.
- **Provider chain awareness**: When modifying a Riverpod provider, trace both
  directions — what it watches (upstream) and what watches it (downstream).
  Changes to a provider's return type or behavior ripple through all consumers.

## Planning for Complex Changes

For tasks that touch 3+ files or cross package boundaries, use plan mode:

1. List all files that will be modified and why.
2. Identify the data flow path (which providers/services are involved).
3. Define the order of changes (start from the lowest-level package, work
   upward).
4. Get user approval before starting implementation.

## Committing Changes

**Never commit without user confirmation.** After implementation is complete:

1. Report what was changed and that the build passes.
2. Wait for the user to run the app and verify the behavior.
3. Only create a commit after the user explicitly confirms the changes are
   working correctly.

Build passing (`flutter build macos`) is a necessary condition but not
sufficient — runtime behavior must be verified by the user before committing.

This holds however obvious the fix looks. A change that compiles, reads
correctly, and addresses a cause you have traced in the source can still do
nothing at all — the real cause may be elsewhere, or the code may never run.
Committing such a change buries a non-fix in the history and makes the next
bisect lie. If verification is blocked, say so and leave the work uncommitted
rather than committing on the strength of the reasoning.

The same applies to library changes (`plough`, `ChiffonDB`, `fonde-ui`): a
passing test suite is not confirmation that the app behaves correctly.

## Progress Logging

Session plans and minutes are managed in the private repository at
`../rinne-graph-desktop-private/`.

**Session start**:

1. Check that `../rinne-graph-desktop-private/` exists. If it does not, inform
   the user before proceeding.
2. Read `../rinne-graph-desktop-private/PLAN.md` and the latest
   `../rinne-graph-desktop-private/sessions/YYYY-MM-DD.md` to restore context.
3. Confirm the day's target with the user before starting implementation.

**Session end**:

1. Update feature status in `../rinne-graph-desktop-private/PLAN.md`.
2. Write `../rinne-graph-desktop-private/sessions/YYYY-MM-DD.md` covering: what
   was done (with commit hashes), decisions made and why, remaining tasks and
   blockers.
3. Remind the user to `git commit` in the private repository.

## Context Limit Behavior

When the context size is approaching its limit, stop trying to complete the
current task and prepare for handoff to a new session. Write the following to a
file (e.g., `docs/handoff.md`):

- Current issues and blockers
- Progress so far (what has been done)
- Next steps (what remains to be done)
