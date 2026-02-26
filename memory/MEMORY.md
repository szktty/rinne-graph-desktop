# Project Memory: rinne-graph-desktop

## Settings Architecture (2026-02-20)

- `core_settings.SettingsManager` manages settings persistence (Settings model with `language: 'en'` default)
- `features_settings.ActiveTheme` watches `settingsManagerProvider` for theme sync
- `core_localization.LocalizationNotifier` is independent (no settings dependency); use `setLocale()` to update
- `features_settings/models/settings.dart` re-exports from `core_settings`
- `features_settings/pubspec.yaml` declares `core_settings` dependency

## Code Generation

- Run `build_runner` per-package: `cd packages/xxx && dart run build_runner build --delete-conflicting-outputs`
- `melos run gen:all` fails (global melos 6.x incompatible with Flutter 3.41.2 Dart kernel binary)
- `core_localization` package has flutter_gen issues; `flutter build macos` still works
- After modifying providers: regenerate in the affected package, then rebuild

## Riverpod 3.x Migration Notes (completed 2026-02-23)

- `XxxNotifierProvider` renamed to `XxxProvider` in riverpod_generator 4.x (Notifier suffix stripped)
- `AsyncValue.valueOrNull` → `AsyncValue.value` (returns null on error in 3.x)
- `StateProvider` and `StateNotifierProvider` require `import 'package:flutter_riverpod/legacy.dart';`
- `StateNotifier` also requires legacy import (7 files updated)
- `searchfield` bumped to ^2.0.0 (1.x incompatible with Flutter 3.41.2 InputDecoration API)
- Migration plan: `docs/progress/flutter-3.41.2-migration-plan.md`

## Flutter Version

- Flutter SDK: 3.41.2 (FVM managed, `.fvmrc`)
- All pubspec.yaml files use `flutter: ">=3.41.2"` (root uses single quotes)

## Build Verification

- Always run from `apps/desktop/`: `flutter build macos`
- `melos run gen:all` fails due to circular deps in `presentation_components → core_stack_flutter`
