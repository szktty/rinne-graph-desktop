---
name: gen-check
description: >-
  Regenerate Riverpod/freezed/JSON code and verify the build. Use after editing
  any @freezed model, @riverpod provider, or JSON-serializable class. Runs
  `melos run gen:all` then a macOS build to confirm no errors.
disable-model-invocation: true
---

# gen-check

Run code generation and verify the build for RinneGraph after changes to
generated-code sources (freezed models, Riverpod providers, JSON serialization).

## Steps

1. **Regenerate** all generated code:

   ```bash
   melos run gen:all
   ```

   This runs `build_runner build --delete-conflicting-outputs` across all
   relevant packages in dependency order.

2. **Report generation result.** If `build_runner` reports conflicts or errors,
   stop and surface the exact error — do not proceed to the build. Common cause:
   a malformed annotation in a source file.

3. **Verify the build** (mandatory per CLAUDE.md after code changes):

   ```bash
   cd apps/desktop && flutter build macos
   ```

4. **Report outcome** plainly:
   - Generation: succeeded / failed (with the error).
   - Build: passed / failed (with the failing file:line).
   - If both pass, state that the build is green but runtime behavior still
     needs the user to verify before committing.

## Notes

- Never hand-edit `*.g.dart` / `*.freezed.dart` — always regenerate. (The
  PreToolUse hook enforces this.)
- A passing build is necessary but not sufficient. Do not commit; per project
  rules, the user verifies runtime behavior first.
