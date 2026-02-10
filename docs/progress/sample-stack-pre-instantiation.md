# Sample Stack Pre-instantiation at App Startup

## Status: Complete (Phase 2 fixes applied)

All implementation steps completed and build passes successfully.

## Phase 2 Fixes

### Fix: Sample stacks not being instantiated
- **Root cause**: `_initializeSampleStackAutoGeneration` in `package_initialization.dart` used `Future.microtask()` which ran asynchronously after `sampleStacksListProvider` was already read by the UI, causing the Samples tab to show empty.
- **Fix**: Moved instantiation logic into `sampleStacksListProvider` itself via `_ensureSampleStacksInstantiated()`. The provider now ensures all templates are instantiated before returning the list.
- **Removed**: `StartupManager._checkAndImportSampleStack()` and `_importSampleStack()` (legacy code that logged "Sample stack auto-creation is disabled").

### Fix: Directory name `App` → `RinneGraph`
- Changed `FlutterPathProvider.getUserSpecificDirectory()` from `~/Documents/App` to `~/Documents/RinneGraph`
- Updated `Stack.isPathScratchStack()` path check
- Updated `StackCreationService._getUserStacksDirectory()` path
- Updated doc comments in `FileSystemService` and `PathProvider`

## Files Modified (Phase 2)

1. `packages/core/stack_flutter/lib/src/providers/stack_providers.dart` - Added `_ensureSampleStacksInstantiated()`, integrated into `sampleStacksListProvider`
2. `packages/core/stack_flutter/lib/src/initialization/package_initialization.dart` - Simplified to only handle first launch flag
3. `apps/desktop/lib/src/services/startup_manager.dart` - Removed legacy sample stack import logic
4. `packages/core/foundation_flutter/lib/src/io/flutter_path_provider.dart` - `App` → `RinneGraph`
5. `packages/core/foundation_flutter/lib/src/filesystem/file_system_service.dart` - Updated doc comments
6. `packages/core/foundation_common/lib/src/io/path_provider.dart` - Updated doc comments
7. `packages/core/stack_common/lib/src/model/stack.dart` - Updated `isPathScratchStack` path
8. `apps/desktop/lib/src/features/import/services/stack_creation_service.dart` - Updated hardcoded path

## Remaining Tasks

- Manual testing: Launch app, verify sample stacks auto-instantiate in ~/Documents/RinneGraph/Samples/
- Verify Samples tab shows instantiated stacks and double-click opens graph correctly
- Verify My Stacks tab is unaffected
